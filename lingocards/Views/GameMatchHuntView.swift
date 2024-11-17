import SwiftUI

struct GameMatchHuntView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameMatchHuntContent()
        }
    }
}

private struct MatchState {
    var leftWords: [WordItemModel] = []
    var rightWords: [WordItemModel] = []
    var matchedIndices: Set<Int> = []
    var selectedLeftIndex: Int?
    var selectedRightIndex: Int?
    var isProcessingMatch: Bool = false
    
    mutating func reset() {
        matchedIndices.removeAll()
        selectedLeftIndex = nil
        selectedRightIndex = nil
        isProcessingMatch = false
    }
    
    var hasSelectedPair: Bool {
        selectedLeftIndex != nil && selectedRightIndex != nil
    }
    
    func canSelectLeft(_ index: Int) -> Bool {
        !isProcessingMatch && !matchedIndices.contains(index) && selectedLeftIndex != index
    }
    
    func canSelectRight(_ index: Int) -> Bool {
        !isProcessingMatch && !matchedIndices.contains(index + leftWords.count) && selectedRightIndex != index
    }
}

private struct GameMatchHuntContent: View {
    // MARK: - Environment
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel
    
    // MARK: - States
    @State private var matchState = MatchState()
    @State private var showAnswerFeedback = false
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    @State private var showSuccessEffect = false
    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
    @State private var isAnswerCorrect = false
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else {
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        matchGridView(width: geometry.size.width)
                    }
                    .padding()
                }
                
                if showAnswerFeedback {
                    AnswerFeedback(
                        isCorrect: isAnswerCorrect,
                        isSpecial: false
                    )
                    .zIndex(1)
                }
            }
        }
        .onAppear { setupGame() }
        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
            if !isLoading { setupGame() }
        }
    }
    
    // MARK: - Match Grid View
    private func matchGridView(width: CGFloat) -> some View {
        HStack(spacing: 16) {
            // Левая колонка
            VStack(spacing: 12) {
                ForEach(matchState.leftWords.indices, id: \.self) { index in
                    WordOptionView(
                        word: matchState.leftWords[index],
                        showTranslation: false,
                        isSelected: index == matchState.selectedLeftIndex,
                        isMatched: matchState.matchedIndices.contains(index),
                        onTap: { selectLeftWord(at: index) }
                    )
                }
            }
            .frame(maxWidth: .infinity)
            
            // Разделитель
            Rectangle()
                .fill(style.theme.accentColor)
                .frame(width: 2)
                .opacity(0.3)
            
            // Правая колонка
            VStack(spacing: 12) {
                ForEach(matchState.rightWords.indices, id: \.self) { index in
                    WordOptionView(
                        word: matchState.rightWords[index],
                        showTranslation: true,
                        isSelected: index == matchState.selectedRightIndex,
                        isMatched: matchState.matchedIndices.contains(index + matchState.leftWords.count),
                        onTap: { selectRightWord(at: index) }
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Game Setup
    private func setupGame() {
        let special = SpecialGoldCard(
            config: .standard,
            showSuccessEffect: $showSuccessEffect
        )
        gameAction.registerSpecial(special)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if cacheGetter.cache.count >= 12 {
                generateNewPairs()
            }
        }
    }
    
    private func generateNewPairs() {
        guard cacheGetter.cache.count >= 12 else { return }
        
        var wordsSet = Set<WordItemModel>()
        while wordsSet.count < 6 {
            if let word = cacheGetter.cache.randomElement() {
                wordsSet.insert(word)
            }
        }
        
        matchState.leftWords = Array(wordsSet)
        matchState.rightWords = Array(wordsSet).shuffled()
        matchState.reset()
        
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0
    }
    
    // MARK: - Selection Handlers
    private func selectLeftWord(at index: Int) {
        guard matchState.canSelectLeft(index) else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            matchState.selectedLeftIndex = index
        }
        
        if matchState.hasSelectedPair {
            checkForMatch()
        }
    }
    
    private func selectRightWord(at index: Int) {
        guard matchState.canSelectRight(index) else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            matchState.selectedRightIndex = index
        }
        
        if matchState.hasSelectedPair {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        guard let leftIndex = matchState.selectedLeftIndex,
              let rightIndex = matchState.selectedRightIndex,
              !matchState.isProcessingMatch else { return }
        
        matchState.isProcessingMatch = true
        
        let leftWord = matchState.leftWords[leftIndex]
        let rightWord = matchState.rightWords[rightIndex]
        
        let responseTime = Date().timeIntervalSince1970 - startTime
        isAnswerCorrect = leftWord.id == rightWord.id
        
        let result = GameVerifyResultModel(
            word: leftWord,
            isCorrect: isAnswerCorrect,
            responseTime: responseTime,
            isSpecial: false,
            hintPenalty: hintPenalty
        )
        
        gameAction.handleGameResult(result)
        
        if isAnswerCorrect {
            FeedbackCorrectAnswerHaptic().playHaptic()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                matchState.matchedIndices.insert(leftIndex)
                matchState.matchedIndices.insert(rightIndex + matchState.leftWords.count)
            }
            
            cacheGetter.removeFromCache(leftWord)
            
            // Сбрасываем состояние выбора сразу
            withAnimation(.easeInOut(duration: 0.2)) {
                matchState.selectedLeftIndex = nil
                matchState.selectedRightIndex = nil
                matchState.isProcessingMatch = false
            }
            
            if matchState.matchedIndices.count % 6 == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    loadMorePairs()
                }
            }
        } else {
            FeedbackWrongAnswerHaptic().playHaptic()
            
            // При неправильном ответе сбрасываем выбор с задержкой
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    matchState.selectedLeftIndex = nil
                    matchState.selectedRightIndex = nil
                    matchState.isProcessingMatch = false
                }
            }
        }
    }
    
    private func loadMorePairs() {
        guard cacheGetter.cache.count >= 3 else { return }
        
        var wordsSet = Set<WordItemModel>()
        while wordsSet.count < 3 {
            if let word = cacheGetter.cache.randomElement() {
                wordsSet.insert(word)
            }
        }
        let newWords = Array(wordsSet)
        
        let matchedLeftIndices = matchState.matchedIndices.filter { $0 < matchState.leftWords.count }
        let matchedRightIndices = matchState.matchedIndices
            .filter { $0 >= matchState.leftWords.count }
            .map { $0 - matchState.leftWords.count }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Заменяем отгаданные слова на новые
            for (i, leftIndex) in matchedLeftIndices.enumerated() {
                matchState.leftWords[leftIndex] = newWords[i]
            }
            
            let shuffledNewWords = newWords.shuffled()
            for (i, rightIndex) in matchedRightIndices.enumerated() {
                matchState.rightWords[rightIndex] = shuffledNewWords[i]
            }
            
            matchState.reset()
        }
    }
}


struct WordOptionView: View {
    let word: WordItemModel
    let showTranslation: Bool
    let isSelected: Bool
    let isMatched: Bool
    let onTap: () -> Void
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    var body: some View {
        Button(action: {
            if !isMatched {
                onTap()
            }
        }) {
            wordContent
        }
        .buttonStyle(WordOptionButtonStyle(isSelected: isSelected, isMatched: isMatched))
    }
    
    private var wordContent: some View {
        Text(showTranslation ? word.backText : word.frontText)
            .font(.system(.body, design: .rounded).weight(.medium))
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 60)
    }
}

// MARK: - Custom Button Style
struct WordOptionButtonStyle: ButtonStyle {
    let isSelected: Bool
    let isMatched: Bool
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
            .background(backgroundColor(isPressed: configuration.isPressed))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderColor, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: shadowColor,
                radius: isSelected ? 5 : 2,
                x: 0,
                y: isSelected ? 2 : 1
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isMatched ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        if isMatched {
            return .gray
        }
        if isSelected {
            return .white
        }
        return style.theme.baseTextColor
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if isMatched {
            return style.theme.backgroundBlockColor.opacity(0.5)
        }
        if isSelected {
            return style.theme.accentColor
        }
        if isPressed {
            return style.theme.backgroundBlockColor.opacity(0.8)
        }
        return style.theme.backgroundBlockColor
    }
    
    private var borderColor: Color {
        if isMatched {
            return .gray.opacity(0.3)
        }
        if isSelected {
            return style.theme.accentColor
        }
        return style.theme.secondaryTextColor.opacity(0.3)
    }
    
    private var shadowColor: Color {
        isSelected ?
        style.theme.accentColor.opacity(0.3) :
        style.theme.secondaryTextColor.opacity(0.1)
    }
}


