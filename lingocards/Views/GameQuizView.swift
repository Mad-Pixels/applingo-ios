import SwiftUI

struct GameQuizView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameQuizContent()
        }
    }
}

struct GameQuizQuestionModel {
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

struct GameQuizContent: View {
    // MARK: - Environment
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel
    
    // MARK: - States
    @State private var currentQuestion: GameQuizQuestionModel?
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
                if let question = currentQuestion {
                    GameQuizCard(
                        question: question,
                        onOptionSelected: handleOptionSelected,
                        onHintUsed: {
                            hintPenalty = 5
                        },
                        specialService: gameAction.specialServiceProvider,
                        hintState: $hintState
                    )
                }
                if showAnswerFeedback {
                    AnswerFeedback(
                        isCorrect: isAnswerCorrect,
                        isSpecial: currentQuestion?.isSpecial ?? false
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
    
    // MARK: - Setup
    private func setupGame() {
        let special = SpecialGoldCard(
            config: .standard,
            showSuccessEffect: $showSuccessEffect
        )
        gameAction.registerSpecial(special)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if cacheGetter.cache.count >= 8 {
                generateNewQuestion()
            }
        }
    }
    
    // MARK: - Question Generation
    private func generateNewQuestion() {
        guard cacheGetter.cache.count >= 8 else { return }
        
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
        
        // Сбрасываем все состояния
        hintState = GameHintState(isShowing: false, wasUsed: false)
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0
        
        // Полностью удаляем текущий вопрос перед созданием нового
        currentQuestion = nil
        
        // Создаем новый вопрос с небольшой задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                currentQuestion = GameQuizQuestionModel(
                    correctWord: correctWord,
                    options: questionWords,
                    isReversed: shouldReverse,
                    isSpecial: gameAction.isSpecial(correctWord)
                )
            }
        }
    }
    
    // MARK: - Answer Handling
    private func handleOptionSelected(_ selectedWord: WordItemModel) {
        guard let question = currentQuestion else { return }
        
        let responseTime = Date().timeIntervalSince1970 - startTime
        isAnswerCorrect = selectedWord.id == question.correctAnswer.id
        
        let result = GameVerifyResultModel(
            word: question.correctWord,
            isCorrect: isAnswerCorrect,
            responseTime: responseTime,
            isSpecial: question.isSpecial,
            hintPenalty: hintPenalty
        )
        
        gameAction.handleGameResult(result)
        
        if isAnswerCorrect {
            FeedbackCorrectAnswerHaptic().playHaptic()
        } else {
            FeedbackWrongAnswerHaptic().playHaptic()
        }
        
        withAnimation {
            showAnswerFeedback = true
        }
        
        cacheGetter.removeFromCache(question.correctWord)
        
        // Увеличиваем задержку перед следующей карточкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showAnswerFeedback = false
                currentQuestion = nil
                
                // Генерируем новую карточку с небольшой задержкой
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    generateNewQuestion()
                }
            }
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
    let question: GameQuizQuestionModel
    let onOptionSelected: (WordItemModel) -> Void
    let onHintUsed: () -> Void
    let specialService: GameSpecialService
    
    @Binding var hintState: GameHintState
    @State private var selectedOption: WordItemModel?
    @State private var isInteractionDisabled = false
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
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
        .id("\(question.correctWord.id ?? 0)-\(question.isReversed)")
    }
    
    private var questionSection: some View {
        VStack(spacing: 16) {
            Text("Выберите перевод")
                .font(GameCardStyle.Typography.captionFont)
                .foregroundColor(style.theme.secondaryTextColor)
                .padding(.top, GameCardStyle.Layout.topPadding)
            
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
        Button(action: { handleOptionTap(option) }) {
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
                    .stroke(getBorderColor(for: option), lineWidth: selectedOption?.id == option.id ? 2 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isInteractionDisabled)
    }
    
    private func getTextColor(for option: WordItemModel) -> Color {
        if selectedOption == nil {
            return selectedOption?.id == option.id ? .white : Color(.label)
        } else {
            return question.correctAnswer.id == option.id ? .white : Color(.label)
        }
    }
    
    private func getBackgroundColor(for option: WordItemModel) -> Color {
        if selectedOption == nil {
            return selectedOption?.id == option.id ? .accentColor : Color(.systemBackground)
        } else {
            if question.correctAnswer.id == option.id {
                return .green
            } else if selectedOption?.id == option.id {
                return .red
            } else {
                return Color(.systemBackground)
            }
        }
    }
    
    private func getBorderColor(for option: WordItemModel) -> Color {
        if selectedOption == nil {
            return selectedOption?.id == option.id ? .clear : Color(.separator)
        } else {
            if question.correctAnswer.id == option.id {
                return .green
            } else if selectedOption?.id == option.id {
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
            
            Button(action: handleHintTap) {
                style.hintButton(isActive: hintState.isShowing)
            }
            .disabled(hintState.wasUsed && hintState.isShowing)
            .padding(.bottom, 20)
        }
    }
    
    private func optionText(for option: WordItemModel) -> String {
        question.isReversed ? option.frontText : option.backText
    }
    
    private func handleOptionTap(_ option: WordItemModel) {
        guard !isInteractionDisabled else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedOption = option
            isInteractionDisabled = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onOptionSelected(option)
        }
    }
    
    private func handleHintTap() {
        withAnimation(.spring()) {
            if !hintState.wasUsed {
                hintState.wasUsed = true
                onHintUsed()
            }
            hintState.isShowing.toggle()
        }
    }
}



