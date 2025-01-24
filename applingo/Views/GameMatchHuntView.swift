//import SwiftUI
//
//struct GameMatchHuntView: View {
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        BaseGameView(isPresented: $isPresented) {
//            GameMatchHuntContent()
//        }
//    }
//}
//
//private struct GameMatchHuntContent: View {
//    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
//    @EnvironmentObject var gameAction: GameActionViewModel
//    
//    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
//    @State private var matchState = MatchCardState()
//    @State private var startTime: TimeInterval = 0
//    @State private var hintPenalty: Int = 0
//    @State private var showAnswerFeedback = false
//    @State private var showSuccessEffect = false
//    @State private var isAnswerCorrect = false
//    
//    @StateObject private var wrongAnswerFeedback: CompositeFeedback = {
//        let feedback = GameFeedback.composite(
//            visualFeedbacks: [],
//            hapticFeedbacks: [
//                FeedbackWrongAnswerHaptic()
//            ]
//        )
//        return feedback
//    }()
//    
//    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
//    
//    var body: some View {
//        ZStack {
//            if cacheGetter.isLoadingCache {
//                CompPreloaderView()
//            } else {
//                GeometryReader { geometry in
//                    VStack(spacing: 20) {
//                        matchGridView(width: geometry.size.width)
//                    }
//                    .padding()
//                }
//                
//                if showAnswerFeedback {
//                    AnswerFeedback(
//                        isCorrect: isAnswerCorrect,
//                        isSpecial: false
//                    )
//                    .zIndex(1)
//                }
//            }
//        }
//        .onAppear { setupGame() }
//        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
//            if !isLoading { setupGame() }
//        }
//    }
//    
//    private func matchGridView(width: CGFloat) -> some View {
//        HStack(spacing: 16) {
//            leftColumn
//            divider
//            rightColumn
//        }
//    }
//    
//    private var leftColumn: some View {
//        VStack(spacing: 12) {
//            ForEach(matchState.leftWords.indices, id: \.self) { index in
//                CompGameMatchWordView(
//                    word: matchState.leftWords[index],
//                    showTranslation: false,
//                    isSelected: index == matchState.selectedLeftIndex,
//                    isMatched: matchState.matchedIndices.contains(index),
//                    onTap: { selectLeftWord(at: index) }
//                )
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//    
//    private var rightColumn: some View {
//        VStack(spacing: 12) {
//            ForEach(matchState.rightWords.indices, id: \.self) { index in
//                CompGameMatchWordView(
//                    word: matchState.rightWords[index],
//                    showTranslation: true,
//                    isSelected: index == matchState.selectedRightIndex,
//                    isMatched: matchState.matchedIndices.contains(index + matchState.leftWords.count),
//                    onTap: { selectRightWord(at: index) }
//                )
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//    
//    private var divider: some View {
//        Rectangle()
//            .fill(style.theme.accentPrimary)
//            .frame(width: 2)
//            .opacity(0.3)
//    }
//    
//    private func setupGame() {
//        let special = SpecialGoldCard(
//            config: .standard,
//            showSuccessEffect: $showSuccessEffect
//        )
//        gameAction.registerSpecial(special)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            if cacheGetter.cache.count >= 12 {
//                generateNewPairs()
//            }
//        }
//    }
//    
//    private func generateNewPairs() {
//        guard cacheGetter.cache.count >= 12 else { return }
//        
//        var wordsSet = Set<DatabaseModelWord>()
//        while wordsSet.count < 6 {
//            if let word = cacheGetter.cache.randomElement() {
//                wordsSet.insert(word)
//            }
//        }
//        
//        matchState.leftWords = Array(wordsSet)
//        matchState.rightWords = Array(wordsSet).shuffled()
//        matchState.reset()
//        
//        startTime = Date().timeIntervalSince1970
//        hintPenalty = 0
//    }
//    
//    private func selectLeftWord(at index: Int) {
//        guard matchState.canSelectLeft(index) else { return }
//        
//        withAnimation(.easeInOut(duration: 0.2)) {
//            matchState.selectedLeftIndex = index
//        }
//        
//        if matchState.hasSelectedPair {
//            checkForMatch()
//        }
//    }
//    
//    private func selectRightWord(at index: Int) {
//        guard matchState.canSelectRight(index) else { return }
//        
//        withAnimation(.easeInOut(duration: 0.2)) {
//            matchState.selectedRightIndex = index
//        }
//        
//        if matchState.hasSelectedPair {
//            checkForMatch()
//        }
//    }
//    
//    private func checkForMatch() {
//        guard let leftIndex = matchState.selectedLeftIndex,
//              let rightIndex = matchState.selectedRightIndex,
//              !matchState.isProcessingMatch else { return }
//        
//        matchState.isProcessingMatch = true
//        
//        let leftWord = matchState.leftWords[leftIndex]
//        let rightWord = matchState.rightWords[rightIndex]
//        
//        processMatchResult(
//            leftWord: leftWord,
//            rightWord: rightWord,
//            leftIndex: leftIndex,
//            rightIndex: rightIndex
//        )
//    }
//    
//    private func processMatchResult(
//        leftWord: DatabaseModelWord,
//        rightWord: DatabaseModelWord,
//        leftIndex: Int,
//        rightIndex: Int
//    ) {
//        let responseTime = Date().timeIntervalSince1970 - startTime
//        isAnswerCorrect = isMatchCorrect(leftWord: leftWord, rightWord: rightWord)
//        
//        let result = GameVerifyResultModel(
//            word: leftWord,
//            isCorrect: isAnswerCorrect,
//            responseTime: responseTime,
//            isSpecial: false,
//            hintPenalty: hintPenalty
//        )
//        
//        gameAction.handleGameResult(result)
//        
//        if isAnswerCorrect {
//            handleCorrectMatch(leftIndex: leftIndex, rightIndex: rightIndex, word: leftWord)
//        } else {
//            handleWrongMatch()
//        }
//    }
//    
//    private func isMatchCorrect(leftWord: DatabaseModelWord, rightWord: DatabaseModelWord) -> Bool {
//        let leftText = leftWord.backText
//        let rightText = rightWord.backText
//        
//        let leftVariants = leftText
//            .lowercased()
//            .split(separator: "|")
//            .map { $0.trimmingCharacters(in: .whitespaces) }
//        
//        let rightVariants = rightText
//            .lowercased()
//            .split(separator: "|")
//            .map { $0.trimmingCharacters(in: .whitespaces) }
//        
//        return !Set(leftVariants).intersection(rightVariants).isEmpty
//    }
//    
//    private func handleCorrectMatch(leftIndex: Int, rightIndex: Int, word: DatabaseModelWord) {
//        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//            matchState.matchedIndices.insert(leftIndex)
//            matchState.matchedIndices.insert(rightIndex + matchState.leftWords.count)
//        }
//        cacheGetter.removeFromCache(word)
//        
//        withAnimation(.easeInOut(duration: 0.2)) {
//            resetSelection()
//        }
//        if matchState.matchedIndices.count % 6 == 0 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                loadMorePairs()
//            }
//        }
//    }
//    
//    private func handleWrongMatch() {
//        wrongAnswerFeedback.trigger()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            withAnimation(.easeInOut(duration: 0.2)) {
//                resetSelection()
//            }
//        }
//    }
//    
//    private func resetSelection() {
//        matchState.selectedLeftIndex = nil
//        matchState.selectedRightIndex = nil
//        matchState.isProcessingMatch = false
//    }
//    
//    private func loadMorePairs() {
//        guard cacheGetter.cache.count >= 3 else { return }
//        
//        let newWords = generateNewWords()
//        updateMatchedWords(with: newWords)
//    }
//    
//    private func generateNewWords() -> [DatabaseModelWord] {
//        var wordsSet = Set<DatabaseModelWord>()
//        while wordsSet.count < 3 {
//            if let word = cacheGetter.cache.randomElement() {
//                wordsSet.insert(word)
//            }
//        }
//        return Array(wordsSet)
//    }
//    
//    private func updateMatchedWords(with newWords: [DatabaseModelWord]) {
//        let matchedLeftIndices = matchState.matchedIndices.filter { $0 < matchState.leftWords.count }
//        let matchedRightIndices = matchState.matchedIndices
//            .filter { $0 >= matchState.leftWords.count }
//            .map { $0 - matchState.leftWords.count }
//        
//        withAnimation(.easeInOut(duration: 0.3)) {
//            for (i, leftIndex) in matchedLeftIndices.enumerated() {
//                matchState.leftWords[leftIndex] = newWords[i]
//            }
//            
//            let shuffledNewWords = newWords.shuffled()
//            for (i, rightIndex) in matchedRightIndices.enumerated() {
//                matchState.rightWords[rightIndex] = shuffledNewWords[i]
//            }
//            
//            matchState.reset()
//        }
//    }
//}
