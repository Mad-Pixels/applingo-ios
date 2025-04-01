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
                        word: card.word
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



import SwiftUI

struct AnimatedSpeakerIcon: View {
    @State private var currentImageIndex = 0
    @State private var timer: Timer?
    let isPlaying: Bool
    let iconColor: Color
    
    let images = ["speaker", "speaker.wave.1", "speaker.wave.2", "speaker.wave.3"]
    
    var body: some View {
        Image(systemName: isPlaying ? images[currentImageIndex] : "speaker.wave.2")
            .font(.system(size: 24))
            .foregroundColor(iconColor)
            .onAppear {
                if isPlaying {
                    startAnimation()
                }
            }
            .onDisappear {
                stopAnimation()
            }
            .onChange(of: isPlaying) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    stopAnimation()
                }
            }
    }
    
    private func startAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                currentImageIndex = (currentImageIndex + 1) % images.count
            }
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

struct ButtonFloatingSpeaker: View {
    let word: DatabaseModelWord
    var iconColor: Color = .white
    var backgroundColor: Color = .blue
    
    @State private var isPlaying: Bool = false
    @State private var observer: NSObjectProtocol?
    
    var body: some View {
        Button(action: {
            if !isPlaying {
                startSpeaking()
            }
        }) {
            AnimatedSpeakerIcon(isPlaying: isPlaying, iconColor: iconColor)
                .frame(width: 44, height: 44)
                .background(Circle().fill(backgroundColor))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                .contentShape(Circle())
        }
        .padding(.bottom, 32)
        .padding(.horizontal, 8)
        .onAppear {
            // Подписываемся на уведомление о завершении
            observer = NotificationCenter.default.addObserver(
                forName: .TTSDidFinishSpeaking,
                object: nil,
                queue: .main
            ) { _ in
                self.isPlaying = false
            }
        }
        .onDisappear {
            // Отписываемся от уведомления при исчезновении вида
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
    
    private func startSpeaking() {
        isPlaying = true
        
        // Запускаем воспроизведение
        TTS.shared.speak(
            word.backText,
            languageCode: word.backTextCode
        )
        
        // Резервный таймер на случай, если уведомление не сработает
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if isPlaying {
                isPlaying = false
            }
        }
    }
}
