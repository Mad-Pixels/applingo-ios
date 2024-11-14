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
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel

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

    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else {
                VStack {
                    HStack {
                        // Левая колонка с frontText
                        VStack {
                            ForEach(leftWords.indices, id: \.self) { index in
                                let word = leftWords[index]
                                WordOptionView(
                                    text: word.frontText,
                                    isSelected: index == selectedLeftIndex,
                                    isMatched: matchedIndices.contains(index),
                                    action: {
                                        selectLeftWord(at: index)
                                    }
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)

                        // Правая колонка с backText
                        VStack {
                            ForEach(rightWords.indices, id: \.self) { index in
                                let word = rightWords[index]
                                WordOptionView(
                                    text: word.backText,
                                    isSelected: index == selectedRightIndex,
                                    isMatched: matchedIndices.contains(index + leftWords.count),
                                    action: {
                                        selectRightWord(at: index)
                                    }
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                if showAnswerFeedback {
                    answerFeedbackView.zIndex(1)
                }
            }
        }
        .onAppear { setupGame() }
        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
            if !isLoading { setupGame() }
        }
    }

    private var answerFeedbackView: some View {
        VStack {
            if gameAction.stats.isLastAnswerCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 60))
            } else {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 60))
            }
        }
    }

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

    private func generateNewPairs() {
        guard cacheGetter.cache.count >= 12 else { return }

        // Берем 6 уникальных случайных слов
        var wordsSet = Set<WordItemModel>()
        while wordsSet.count < 6 {
            if let word = cacheGetter.cache.randomElement() {
                wordsSet.insert(word)
            }
        }
        let words = Array(wordsSet)

        leftWords = words
        rightWords = words

        matchedIndices.removeAll()
        selectedLeftIndex = nil
        selectedRightIndex = nil
        hintState = GameHintState(isShowing: false, wasUsed: false)
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0

        // Перемешиваем правую колонку
        rightWords.shuffle()
    }

    private func selectLeftWord(at index: Int) {
        guard !matchedIndices.contains(index) else { return }
        selectedLeftIndex = index
        checkForMatch()
    }

    private func selectRightWord(at index: Int) {
        guard !matchedIndices.contains(index + leftWords.count) else { return }
        selectedRightIndex = index
        checkForMatch()
    }

    private func checkForMatch() {
        guard let leftIndex = selectedLeftIndex, let rightIndex = selectedRightIndex else { return }

        let leftWord = leftWords[leftIndex]
        let rightWord = rightWords[rightIndex]

        guard let leftWordId = leftWord.id, let rightWordId = rightWord.id else { return }

        let responseTime = Date().timeIntervalSince1970 - startTime
        let isCorrect = leftWordId == rightWordId
        let isSpecial = gameAction.isSpecial(leftWord)
        let result = GameVerifyResultModel(
            word: leftWord,
            isCorrect: isCorrect,
            responseTime: responseTime,
            isSpecial: isSpecial,
            hintPenalty: hintPenalty
        )
        gameAction.handleGameResult(result)

        if isCorrect {
            matchedIndices.insert(leftIndex)
            matchedIndices.insert(rightIndex + leftWords.count)
            cacheGetter.removeFromCache(leftWord)

            if matchedIndices.count % 6 == 0 {
                loadMorePairs()
            }
        } else {
            FeedbackWrongAnswerHaptic().playHaptic()
        }

        withAnimation {
            showAnswerFeedback = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showAnswerFeedback = false
            }
            selectedLeftIndex = nil
            selectedRightIndex = nil
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
        let matchedRightIndices = matchedIndices.filter { $0 >= leftWords.count }.map { $0 - leftWords.count }

        // Заменяем отгаданные слова на новые, оставляя остальные на тех же местах
        for (i, leftIndex) in matchedLeftIndices.enumerated() {
            leftWords[leftIndex] = newWords[i]
        }
        for (i, rightIndex) in matchedRightIndices.enumerated() {
            rightWords[rightIndex] = newWords[i]
        }

        // Удаляем использованные индексы из matchedIndices
        matchedIndices.subtract(matchedLeftIndices)
        matchedIndices.subtract(matchedRightIndices.map { $0 + leftWords.count })

        // Перемешиваем только новые элементы в правой колонке
        let unmatchedRightIndices = Set(rightWords.indices).subtracting(matchedIndices.filter { $0 >= leftWords.count }.map { $0 - leftWords.count })
        let newRightWords = unmatchedRightIndices.map { rightWords[$0] }
        rightWords = newRightWords.shuffled() + rightWords.enumerated().filter { !unmatchedRightIndices.contains($0.offset) }.map { $0.element }
    }
}


struct WordOptionView: View {
    let text: String
    let isSelected: Bool
    let isMatched: Bool
    let action: () -> Void

    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(isMatched ? .gray : (isSelected ? .blue : .primary))
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            )
            .onTapGesture {
                if !isMatched {
                    action()
                }
            }
            .opacity(isMatched ? 0.5 : 1.0)
    }
}

extension WordItemModel: Hashable {
    static func == (lhs: WordItemModel, rhs: WordItemModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
