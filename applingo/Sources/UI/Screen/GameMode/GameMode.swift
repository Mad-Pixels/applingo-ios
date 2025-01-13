import SwiftUI

struct GameMode: View {
    @Binding var isCoverPresented: Bool  // Флаг для закрытия всего
    @StateObject private var style: GameModeStyle = .themed(ThemeManager.shared.currentThemeStyle)
    private let locale: GameModeLocale = GameModeLocale()
    
    // Режимы
    @Binding var selectedMode: GameModeEnum
    let startGame: () -> Void

    // Анимация + пуш
    @State private var isAnimating = false
    @State private var showQuizGame = false

    // Упрощённый init (можно расширять по желанию)
    init(
        isCoverPresented: Binding<Bool>,
        selectedMode: Binding<GameModeEnum> = .constant(.practice),
        startGame: @escaping () -> Void = {}
    ) {
        self._isCoverPresented = isCoverPresented
        self._selectedMode = selectedMode
        self.startGame = startGame
    }

    var body: some View {
        ZStack {
            MainBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: style.spacing) {
                Text(locale.selectModeTitle.uppercased())
                    .font(style.titleStyle.font)
                    .foregroundColor(style.titleStyle.color)
                    .padding(.top)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)

                VStack(spacing: style.cardSpacing) {
                    GameModeViewCard(
                        mode: .practice,
                        icon: "graduationcap.fill",
                        title: locale.practiceTitle,
                        description: locale.practiceDescription,
                        style: style,
                        isSelected: false,
                        onSelect: {
                            selectMode(.practice)
                        }
                    )
                    GameModeViewCard(
                        mode: .survival,
                        icon: "heart.fill",
                        title: locale.survivalTitle,
                        description: locale.survivalDescription,
                        style: style,
                        isSelected: false,
                        onSelect: {
                            selectMode(.survival)
                        }
                    )
                    GameModeViewCard(
                        mode: .timeAttack,
                        icon: "timer",
                        title: locale.timeAttackTitle,
                        description: locale.timeAttackDescription,
                        style: style,
                        isSelected: false,
                        onSelect: {
                            selectMode(.timeAttack)
                        }
                    )
                }

                // NavigationLink → QuizGameContent
                NavigationLink(isActive: $showQuizGame) {
                    QuizGameContent(
                        isPresented: $showQuizGame,
                        closeFullScreen: $isCoverPresented  // Тоже прокидываем
                    )
                } label: {
                    EmptyView()
                }
                .hidden()
            }
        }
        .toolbar {
            // «Крестик» справа закрывает всё
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isCoverPresented = false // Закрыть полный экран
                }) {
                    Image(systemName: "xmark")
                }
            }
        }
        .navigationBarTitle("Game Mode", displayMode: .inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }

    private func selectMode(_ mode: GameModeEnum) {
        selectedMode = mode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showQuizGame = true
            startGame()
        }
    }
}
