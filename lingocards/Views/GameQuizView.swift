import SwiftUI

struct GameQuizView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameQuizContent()
        }
    }
}

struct GameQuizQuestionModel: Equatable {
    let correctWord: WordItemModel
    let options: [WordItemModel]
    let isReversed: Bool
    let isSpecial: Bool
    
    var questionText: String {
        isReversed ? correctWord.backText : correctWord.frontText
    }
    
    var correctAnswer: WordItemModel {
        correctWord
    }
    
    var hintText: String? {
        correctWord.hint
    }
}

struct QuizCardState {
    var selectedOptionId: Int?
    var isInteractionDisabled: Bool
    var showCorrectAnswer: Bool
    
    static let initial = QuizCardState(
        selectedOptionId: nil,
        isInteractionDisabled: false,
        showCorrectAnswer: false
    )
}


struct GameQuizContent: View {
    // MARK: - Environment
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel
    
    // MARK: - States
    @State private var currentQuestion: GameQuizQuestionModel?
    @State private var cardState = QuizCardState.initial
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
    @State private var isAnswerCorrect = false
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else if let question = currentQuestion {
                GameQuizCard(
                    question: question,
                    cardState: cardState,
                    hintState: hintState,
                    style: style,
                    specialService: gameAction.specialServiceProvider,
                    onOptionSelected: handleOptionTap,
                    onHintTap: handleHintTap
                )
            }
        }
        .onAppear(perform: setupGame)
        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
            if !isLoading { setupGame() }
        }
    }
    
    // MARK: - Setup
    private func setupGame() {
        let special = SpecialGoldCard(config: .standard, showSuccessEffect: .constant(false))
        gameAction.registerSpecial(special)
        generateNewQuestion()
    }
    
    // MARK: - Question Generation
    private func generateNewQuestion() {
        guard cacheGetter.cache.count >= 8 else { return }
        
        // Сбрасываем все состояния
        cardState = QuizCardState.initial
        hintState = GameHintState(isShowing: false, wasUsed: false)
        hintPenalty = 0
        
        // Генерируем новый вопрос
        let shouldReverse = Int.random(in: 1...100) <= 40
        var questionWords = Array(cacheGetter.cache.shuffled().prefix(4))
        questionWords = Array(Set(questionWords))
        
        if questionWords.count < 4 {
            let remainingWords = cacheGetter.cache.filter { !questionWords.contains($0) }
            questionWords.append(contentsOf: remainingWords.shuffled().prefix(4 - questionWords.count))
        }
        
        guard questionWords.count >= 4 else { return }
        questionWords = Array(questionWords.prefix(4))
        
        let correctWord = questionWords.randomElement()!
        questionWords.shuffle()
        
        startTime = Date().timeIntervalSince1970
        
        currentQuestion = GameQuizQuestionModel(
            correctWord: correctWord,
            options: questionWords,
            isReversed: shouldReverse,
            isSpecial: gameAction.isSpecial(correctWord)
        )
    }
    
    // MARK: - Actions
    private func handleOptionTap(_ option: WordItemModel) {
        guard let question = currentQuestion,
              !cardState.isInteractionDisabled else { return }
        
        // Обновляем состояние карточки
        withAnimation(.easeOut(duration: 0.2)) {
            cardState.selectedOptionId = option.id
            cardState.isInteractionDisabled = true
        }
        
        let isCorrect = option.id == question.correctAnswer.id
        
        if isCorrect {
            handleCorrectAnswer(option)
        } else {
            handleWrongAnswer(option)
        }
    }
    
    private func handleCorrectAnswer(_ option: WordItemModel) {
        guard let question = currentQuestion else { return }
        
        FeedbackCorrectAnswerHaptic().playHaptic()
        
        let result = createGameResult(for: option, isCorrect: true)
        gameAction.handleGameResult(result)
        cacheGetter.removeFromCache(question.correctWord)
        
        // Быстрый переход к следующему вопросу
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            generateNewQuestion()
        }
    }
    
    private func handleWrongAnswer(_ option: WordItemModel) {
        guard let question = currentQuestion else { return }
        
        FeedbackWrongAnswerHaptic().playHaptic()
        
        let result = createGameResult(for: option, isCorrect: false)
        gameAction.handleGameResult(result)
        
        // Показываем правильный ответ
        withAnimation(.easeOut(duration: 0.2)) {
            cardState.showCorrectAnswer = true
        }
        
        // Переход к следующему вопросу с задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            generateNewQuestion()
        }
    }
    
    private func createGameResult(for option: WordItemModel, isCorrect: Bool) -> GameVerifyResultModel {
        guard let question = currentQuestion else {
            fatalError("Attempting to create result without question")
        }
        
        return GameVerifyResultModel(
            word: question.correctWord,
            isCorrect: isCorrect,
            responseTime: Date().timeIntervalSince1970 - startTime,
            isSpecial: question.isSpecial,
            hintPenalty: hintPenalty
        )
    }
    
    private func handleHintTap() {
        if !hintState.wasUsed {
            hintState.wasUsed = true
            hintPenalty += 5
        } else {
            hintPenalty += 2
        }
        
        withAnimation(.spring()) {
            hintState.isShowing.toggle()
        }
    }
}

struct AnswerFeedback: View {
    let isCorrect: Bool
    let isSpecial: Bool
    
    var body: some View {
        if isSpecial && isCorrect {
            Image(systemName: "star.circle.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 80))
                .transition(.scale.combined(with: .opacity))
        } else {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.clear)
                .transition(.scale.combined(with: .opacity))
        }
    }
}


struct GameQuizCard: View {
    // MARK: - Properties
    let question: GameQuizQuestionModel
    let cardState: QuizCardState
    let hintState: GameHintState
    let style: GameCardStyle
    let specialService: GameSpecialService
    let onOptionSelected: (WordItemModel) -> Void
    let onHintTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            questionSection
            Spacer()
            optionsSection
            Spacer()
            
            if let hint = question.hintText {
                hintSection(hint)
            }
        }
        .gameCardStyle(style)
        .gameCardSpecialEffects(
            style: style,
            isSpecial: question.isSpecial,
            specialService: specialService
        )
    }
    
    private var questionSection: some View {
        VStack() {
            style.mainText(question.questionText)
                .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
        }
    }
    
    private var optionsSection: some View {
        VStack(spacing: 12) {
            ForEach(question.options) { option in
                optionButton(for: option)
            }
        }
        .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
    }
    
    private func optionButton(for option: WordItemModel) -> some View {
        Button(action: { onOptionSelected(option) }) {
            HStack {
                Text(optionText(for: option))
                    .font(GameCardStyle.Typography.titleFont)
                    .foregroundColor(getTextColor(for: option))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(getBackgroundColor(for: option))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(getBorderColor(for: option), lineWidth: cardState.selectedOptionId == option.id ? 2 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(cardState.isInteractionDisabled)
    }
    
    private func getTextColor(for option: WordItemModel) -> Color {
        if cardState.selectedOptionId == nil {
            return cardState.selectedOptionId == option.id ? .white : Color(.label)
        } else {
            return question.correctAnswer.id == option.id ? .white : Color(.label)
        }
    }
    
    private func getBackgroundColor(for option: WordItemModel) -> Color {
        if cardState.selectedOptionId == nil {
            return cardState.selectedOptionId == option.id ? .accentColor : Color(.systemBackground)
        } else {
            if question.correctAnswer.id == option.id {
                return .green
            } else if cardState.selectedOptionId == option.id {
                return .red
            } else {
                return Color(.systemBackground)
            }
        }
    }
    
    private func getBorderColor(for option: WordItemModel) -> Color {
        if cardState.selectedOptionId == nil {
            return cardState.selectedOptionId == option.id ? .clear : Color(.separator)
        } else {
            if question.correctAnswer.id == option.id {
                return .green
            } else if cardState.selectedOptionId == option.id {
                return .red
            } else {
                return Color(.separator)
            }
        }
    }
    
    private func hintSection(_ hint: String) -> some View {
        VStack {
            if hintState.isShowing {
                style.hintContainer {
                    style.hintPenalty()
                    
                    Text(hint)
                        .font(GameCardStyle.Typography.hintFont)
                        .foregroundColor(style.theme.secondaryTextColor)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: onHintTap) {
                style.hintButton(isActive: hintState.isShowing)
            }
            .disabled(hintState.wasUsed && hintState.isShowing)
            .padding(.bottom, 20)
        }
    }
    
    private func optionText(for option: WordItemModel) -> String {
        question.isReversed ? option.frontText : option.backText
    }
}

// MARK: - Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
