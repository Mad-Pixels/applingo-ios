import SwiftUI

struct GameQuizView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameQuizContent()
        }
    }
}



private struct GameQuizContent: View {
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel

    @State private var currentQuestion: GameQuizQuestionModel?
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
            if let question = currentQuestion,
               question.isSpecial && gameAction.stats.isLastAnswerCorrect {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 80))
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: gameAction.stats.isLastAnswerCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .foregroundColor(gameAction.stats.isLastAnswerCorrect ? .green : .red)
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
            if cacheGetter.cache.count >= 8 {
                generateNewQuestion()
            }
        }
    }
    
    private func generateNewQuestion() {
        guard cacheGetter.cache.count >= 8 else { return }
        
        let shouldReverse = Int.random(in: 1...100) <= 40  // 40% шанс перевернуть
        var questionWords = Array(cacheGetter.cache.shuffled().prefix(4))
        guard questionWords.count == 4 else { return }
        
        let correctWord = questionWords.randomElement()!
        questionWords.shuffle()
        
        hintState = GameHintState(isShowing: false, wasUsed: false)
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0
        
        withAnimation {
            currentQuestion = GameQuizQuestionModel(
                correctWord: correctWord,
                options: questionWords,
                isReversed: shouldReverse,
                isSpecial: gameAction.isSpecial(correctWord)
            )
        }
    }
    
    private func handleOptionSelected(_ selectedWord: WordItemModel) {
        guard let question = currentQuestion else { return }
        
        let responseTime = Date().timeIntervalSince1970 - startTime
        let isCorrect = selectedWord.id == question.correctAnswer.id
        let result = GameVerifyResultModel(
            word: question.correctWord,
            isCorrect: isCorrect,
            responseTime: responseTime,
            isSpecial: question.isSpecial,
            hintPenalty: hintPenalty
        )
        gameAction.handleGameResult(result)
        
        if !isCorrect {
            FeedbackWrongAnswerHaptic().playHaptic()
        }
        
        withAnimation {
            showAnswerFeedback = true
        }
        cacheGetter.removeFromCache(question.correctWord)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showAnswerFeedback = false
                currentQuestion = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                generateNewQuestion()
            }
        }
    }
}

import Foundation

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
}



import SwiftUI

struct GameQuizCard: View {
    let question: GameQuizQuestionModel
    let onOptionSelected: (WordItemModel) -> Void
    let onHintUsed: () -> Void
    let specialService: GameSpecialService
    @Binding var hintState: GameHintState
    
    let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    var body: some View {
        VStack(spacing: 0) {
            if hintState.isShowing {
                style.hintContainer {
                    Text(hintText)
                        .font(GameCardStyle.Typography.hintFont)
                        .foregroundColor(style.theme.secondaryTextColor)
                }
            }
            
            Spacer()
            
            style.mainText(question.questionText)
                .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
            
            Spacer()
            
            VStack(spacing: 12) {
                ForEach(question.options, id: \.id) { option in
                    Button(action: {
                        onOptionSelected(option)
                    }) {
                        Text(optionText(for: option))
                            .font(GameCardStyle.Typography.titleFont)
                            .foregroundColor(style.theme.baseTextColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(style.theme.secondaryTextColor)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                if !hintState.wasUsed {
                    hintState.isShowing = true
                    hintState.wasUsed = true
                    onHintUsed()
                }
            }) {
                style.hintButton(isActive: hintState.wasUsed)
            }
            .padding(.bottom, 20)
        }
        .modifier(style.makeBaseModifier())
        .modifier(style.makeSpecialEffectsModifier(isSpecial: question.isSpecial, specialService: specialService))
    }
    
    private func optionText(for option: WordItemModel) -> String {
        question.isReversed ? option.frontText : option.backText
    }
    
    private var hintText: String {
        // Предоставляем подсказку для правильного ответа
        if question.isReversed {
            return "Подсказка: \(question.correctWord.frontText)"
        } else {
            return "Подсказка: \(question.correctWord.backText)"
        }
    }
}
