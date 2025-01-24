//import SwiftUI
//
//struct GameQuizView: View {
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        BaseGameView(isPresented: $isPresented) {
//            GameQuizContent()
//        }
//    }
//}
//
//struct GameQuizContent: View {
//    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
//    @EnvironmentObject var gameAction: GameActionViewModel
//        
//    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
//    @State private var currentQuestion: GameQuizCardModel?
//    @State private var cardState = QuizCardState.initial
//    @State private var startTime: TimeInterval = 0
//    @State private var hintPenalty: Int = 0
//    @State private var isAnswerCorrect = false
//    @State private var isShaking = false
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
//            } else if let question = currentQuestion {
//                CompGameQuizCardView(
//                    question: question,
//                    cardState: cardState,
//                    hintState: hintState,
//                    style: style,
//                    specialService: gameAction.specialServiceProvider,
//                    onOptionSelected: handleOptionTap,
//                    onHintTap: handleHintTap
//                )
//                .modifier(FeedbackShake(isActive: $isShaking).modifier())
//            }
//        }
//        .onAppear(perform: setupGame)
//        .onAppear {
//            wrongAnswerFeedback.addFeedbacks([
//                FeedbackShake(isActive: $isShaking, duration: 0.07)
//            ])
//        }
//        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
//            if !isLoading { setupGame() }
//        }
//    }
//    
//    private func setupGame() {
//        let special = SpecialGoldCard(config: .standard, showSuccessEffect: .constant(false))
//        gameAction.registerSpecial(special)
//        generateNewQuestion()
//    }
//    
//    private func generateNewQuestion() {
//        guard cacheGetter.cache.count >= 8 else { return }
//        
//        resetStates()
//        let question = createQuestion()
//        
//        startTime = Date().timeIntervalSince1970
//        currentQuestion = question
//    }
//    
//    private func resetStates() {
//        cardState = QuizCardState.initial
//        hintState = GameHintState(isShowing: false, wasUsed: false)
//        hintPenalty = 0
//    }
//    
//    private func createQuestion() -> GameQuizCardModel {
//        let shouldReverse = Int.random(in: 1...100) <= 40
//        var questionWords = Array(cacheGetter.cache.shuffled().prefix(4))
//        questionWords = Array(Set(questionWords))
//        
//        if questionWords.count < 4 {
//            let remainingWords = cacheGetter.cache.filter { !questionWords.contains($0) }
//            questionWords.append(contentsOf: remainingWords.shuffled().prefix(4 - questionWords.count))
//        }
//        
//        guard questionWords.count >= 4 else {
//            fatalError("Not enough words to create a question")
//        }
//        
//        let correctWord = questionWords.randomElement()!
//        questionWords.shuffle()
//        
//        return GameQuizCardModel(
//            correctWord: correctWord,
//            options: Array(questionWords.prefix(4)),
//            isReversed: shouldReverse,
//            isSpecial: gameAction.isSpecial(correctWord)
//        )
//    }
//    
//    private func handleOptionTap(_ option: DatabaseModelWord) {
//        guard let question = currentQuestion,
//              !cardState.isInteractionDisabled else { return }
//        
//        let isCorrect = isAnswerCorrect(selected: option, question: question)
//        
//        withAnimation(.easeOut(duration: 0.2)) {
//            cardState.selectedOptionId = option.id
//            cardState.isInteractionDisabled = true
//        }
//        
//        isCorrect ? handleCorrectAnswer(option) : handleWrongAnswer(option)
//    }
//    
//    private func isAnswerCorrect(selected: DatabaseModelWord, question: GameQuizCardModel) -> Bool {
//        let selectedText = question.isReversed ? selected.frontText : selected.backText
//        let correctText = question.isReversed ? question.correctAnswer.frontText : question.correctAnswer.backText
//        
//        return compareAnswers(selectedText, correctText)
//    }
//    
//    private func compareAnswers(_ selected: String, _ correct: String) -> Bool {
//        let selectedVariants = selected
//            .lowercased()
//            .split(separator: "|")
//            .map { $0.trimmingCharacters(in: .whitespaces) }
//        
//        let correctVariants = correct
//            .lowercased()
//            .split(separator: "|")
//            .map { $0.trimmingCharacters(in: .whitespaces) }
//        
//        return !Set(selectedVariants).intersection(correctVariants).isEmpty
//    }
//        
//    private func handleCorrectAnswer(_ option: DatabaseModelWord) {
//        guard let question = currentQuestion else { return }
//        
//        let result = createGameResult(for: option, isCorrect: true)
//        gameAction.handleGameResult(result)
//        cacheGetter.removeFromCache(question.correctWord)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            generateNewQuestion()
//        }
//    }
//
//    private func handleWrongAnswer(_ option: DatabaseModelWord) {
//        wrongAnswerFeedback.trigger()
//        
//        let result = createGameResult(for: option, isCorrect: false)
//        gameAction.handleGameResult(result)
//        
//        withAnimation(.easeOut(duration: 0.3)) {
//            cardState.showCorrectAnswer = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//            generateNewQuestion()
//        }
//    }
//    
//    private func createGameResult(for option: DatabaseModelWord, isCorrect: Bool) -> GameVerifyResultModel {
//        guard let question = currentQuestion else {
//            fatalError("Attempting to create result without question")
//        }
//        
//        return GameVerifyResultModel(
//            word: question.correctWord,
//            isCorrect: isCorrect,
//            responseTime: Date().timeIntervalSince1970 - startTime,
//            isSpecial: question.isSpecial,
//            hintPenalty: hintPenalty
//        )
//    }
//    
//    private func handleHintTap() {
//        if !hintState.wasUsed {
//            hintState.wasUsed = true
//            hintPenalty += 5
//        } else {
//            hintPenalty += 2
//        }
//        
//        withAnimation(.spring()) {
//            hintState.isShowing.toggle()
//        }
//    }
//}
