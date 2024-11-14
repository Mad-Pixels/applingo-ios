import SwiftUI

struct GameMatchHuntView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameMatchHuntContent()
        }
    }
}

private struct GameMatchHuntContent: View {
    // MARK: - Environment
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel
    
    // MARK: - States
    @State private var leftWords: [WordItemModel] = []
    @State private var rightWords: [WordItemModel] = []
    @State private var matchedIndices: Set<Int> = []
    @State private var selectedLeftIndex: Int?
    @State private var selectedRightIndex: Int?
    @State private var showAnswerFeedback = false
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    @State private var showSuccessEffect = false
    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
    @State private var isAnswerCorrect = false
    @State private var showFeedbackBorder = false
    
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
                        isSpecial: false  // Пока не используем специальные карточки в этом режиме
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
                ForEach(leftWords.indices, id: \.self) { index in
                    WordOptionView(
                        word: leftWords[index],
                        showTranslation: false,
                        isSelected: index == selectedLeftIndex,
                        isMatched: matchedIndices.contains(index),
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
                ForEach(rightWords.indices, id: \.self) { index in
                    WordOptionView(
                        word: rightWords[index],
                        showTranslation: true,
                        isSelected: index == selectedRightIndex,
                        isMatched: matchedIndices.contains(index + leftWords.count),
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if cacheGetter.cache.count >= 12 {
                generateNewPairs()
            }
        }
    }
    
    // MARK: - Game Logic
    private func generateNewPairs() {
        guard cacheGetter.cache.count >= 12 else { return }
        
        var wordsSet = Set<WordItemModel>()
        while wordsSet.count < 6 {
            if let word = cacheGetter.cache.randomElement() {
                wordsSet.insert(word)
            }
        }
        
        // Отключаем анимацию для начальной загрузки
        withAnimation(nil) {
            leftWords = Array(wordsSet)
            rightWords = Array(wordsSet).shuffled()
            matchedIndices.removeAll()
            selectedLeftIndex = nil
            selectedRightIndex = nil
            hintState = GameHintState(isShowing: false, wasUsed: false)
            startTime = Date().timeIntervalSince1970
            hintPenalty = 0
        }
    }
    
    // MARK: - Selection Handlers
    private func selectLeftWord(at index: Int) {
        guard !matchedIndices.contains(index) else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedLeftIndex = index
        }
        checkForMatch()
    }
    
    private func selectRightWord(at index: Int) {
        guard !matchedIndices.contains(index + leftWords.count) else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedRightIndex = index
        }
        checkForMatch()
    }
    
    private func checkForMatch() {
        guard let leftIndex = selectedLeftIndex,
              let rightIndex = selectedRightIndex,
              let leftWordId = leftWords[leftIndex].id,
              let rightWordId = rightWords[rightIndex].id
        else { return }
        
        let responseTime = Date().timeIntervalSince1970 - startTime
        isAnswerCorrect = leftWordId == rightWordId
        
        let result = GameVerifyResultModel(
            word: leftWords[leftIndex],
            isCorrect: isAnswerCorrect,
            responseTime: responseTime,
            isSpecial: false,
            hintPenalty: hintPenalty
        )
        gameAction.handleGameResult(result)
        
        if isAnswerCorrect {
            FeedbackCorrectAnswerHaptic().playHaptic()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                matchedIndices.insert(leftIndex)
                matchedIndices.insert(rightIndex + leftWords.count)
            }
            cacheGetter.removeFromCache(leftWords[leftIndex])
            
            if matchedIndices.count % 6 == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    loadMorePairs()
                }
            }
        } else {
            FeedbackWrongAnswerHaptic().playHaptic()
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showAnswerFeedback = true
        }
        
        // Сбрасываем выбор с небольшой задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showAnswerFeedback = false
                if !isAnswerCorrect {
                    selectedLeftIndex = nil
                    selectedRightIndex = nil
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
            
            // Находим индексы отгаданных пар
            let matchedLeftIndices = matchedIndices.filter { $0 < leftWords.count }
            let matchedRightIndices = matchedIndices.filter { $0 >= leftWords.count }
                .map { $0 - leftWords.count }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                // Заменяем отгаданные слова на новые
                for (i, leftIndex) in matchedLeftIndices.enumerated() {
                    leftWords[leftIndex] = newWords[i]
                }
                
                // Перемешиваем новые слова для правой колонки
                let shuffledNewWords = newWords.shuffled()
                for (i, rightIndex) in matchedRightIndices.enumerated() {
                    rightWords[rightIndex] = shuffledNewWords[i]
                }
                
                // Очищаем использованные индексы
                matchedIndices.removeAll()
                selectedLeftIndex = nil
                selectedRightIndex = nil
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


