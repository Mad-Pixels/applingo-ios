import SwiftUI

struct GameQuiz: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @StateObject private var viewModel: QuizViewModel
    
    @ObservedObject var game: Quiz
    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?
    
    init(
        game: Quiz,
        style: GameQuizStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(game: game))
        _style = StateObject(wrappedValue: style)
        self.game = game
    }
    
    var body: some View {
        ZStack {
            style.backgroundColor.ignoresSafeArea()
            
            if shouldShowPreloader {
                ItemListLoading(style: .themed(themeManager.currentThemeStyle))
            }
            
            if let card = viewModel.currentCard {
                VStack {
                    VStack(spacing: style.optionsSpacing) {
                        GameQuizViewQuestion(
                            locale: locale,
                            style: style,
                            question: card.question
                        )
                        .padding(.vertical, style.optionsSpacing)
                        
                        ForEach(card.options, id: \.self) { option in
                            GameQuizViewAnswer(
                                style: style,
                                locale: locale,
                                option: option,
                                onSelect: { viewModel.handleAnswer(option) },
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.top, 128)
                    
                    Spacer()
                    
                    ButtonFloatingSpeaker(
                        word: card,
                        style: style
                    )
                    .padding(.bottom, 32)
                    .padding(.horizontal, 8)
                }
            }
        }
        .onAppear {
            viewModel.generateCard()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            if isLoading {
                preloaderTimer?.cancel()
                
                let timer = DispatchWorkItem {
                    if viewModel.isLoadingCard {
                        shouldShowPreloader = true
                    }
                }
                preloaderTimer = timer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: timer)
            } else {
                preloaderTimer?.cancel()
                preloaderTimer = nil
                
                shouldShowPreloader = false
            }
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
}



struct ButtonFloatingSpeaker: View {
    let word: QuizModelCard
    let style: GameQuizStyle
    
    @State private var isPlaying: Bool = false
    @State private var waveLevel: Int = 0
    @State private var animationTimer: Timer? = nil
    
    var body: some View {
        Button(action: {
            if !isPlaying {
                startSpeaking()
            }
        }) {
            Image(systemName: getIconName())
                .font(.system(size: 24))
                .foregroundColor(isPlaying ? .blue : .red)
                .frame(width: 44, height: 44)
                .background(Circle().fill(style.backgroundColor))
                //.shadow(color: style.shadowColor.opacity(0.2), radius: 4, x: 0, y: 2)
                .contentShape(Circle())
        }
        .padding(.bottom, 32)
        .padding(.horizontal, 8)
    }
    
    private func getIconName() -> String {
        if !isPlaying {
            return "speaker.wave.2"
        }
        
        switch waveLevel {
            case 0: return "speaker"
            case 1: return "speaker.wave.1"
            case 2: return "speaker.wave.2"
            case 3: return "speaker.wave.3"
            default: return "speaker.wave.2"
        }
    }
    
    private func startSpeaking() {
        // Начать воспроизведение
        isPlaying = true
        
        // Запустить анимацию
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                waveLevel = (waveLevel + 1) % 4
            }
        }
        
        // Запустить TTS
        TTS.shared.speak(
            word.question,
            languageCode: "ru"
        )
        
        // Подписаться на уведомление о завершении TTS (предполагая, что ваш TTS отправляет такое уведомление)
        NotificationCenter.default.addObserver(
            forName: Notification.Name("TTSDidFinishSpeaking"),
            object: nil,
            queue: .main
        ) { _ in
            stopSpeakingAnimation()
        }
        
        // Резервный таймер на случай, если уведомление не придет
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if isPlaying {
                stopSpeakingAnimation()
            }
        }
    }
    
    private func stopSpeakingAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        
        withAnimation {
            isPlaying = false
        }
        
        // Удалить наблюдателя
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("TTSDidFinishSpeaking"),
            object: nil
        )
    }
}
