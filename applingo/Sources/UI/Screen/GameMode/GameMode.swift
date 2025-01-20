import SwiftUI

struct GameMode: View {
    let game: any AbstractGame
    @Binding var isPresented: Bool
    
    private let locale: GameModeLocale = GameModeLocale()
    @StateObject private var style: GameModeStyle
    @State private var selectedMode: GameModeEnum = .practice
    @State private var isPressedTrailing = false
    @State private var isPressedLeading = false
    @State private var showGameContent = false
    @State private var isAnimating = false
    
    init(
        game: any AbstractGame,
        isPresented: Binding<Bool>,
        style: GameModeStyle? = nil
    ) {
        self.game = game
        self._isPresented = isPresented
        let initialStyle = style ?? .themed(
            ThemeManager.shared.currentThemeStyle,
            gameTheme: game.theme
        )
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseGameScreen(screen: .game, game: game) {
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
                        isSelected: selectedMode == .practice,
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
                        isSelected: selectedMode == .survival,
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
                        isSelected: selectedMode == .timeAttack,
                        onSelect: {
                            selectMode(.timeAttack)
                        }
                    )
                }
            }
            .padding(style.padding)
            .navigationBarItems(
                trailing: ButtonNav(
                    style: .close(ThemeManager.shared.currentThemeStyle),
                    onTap: {
                        isPresented = false
                    },
                    isPressed: $isPressedTrailing
                )
            )
            .background(
                NavigationLink(isActive: $showGameContent) {
                    makeGameContent()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(
                            leading: ButtonNav(
                                style: .back(ThemeManager.shared.currentThemeStyle),
                                onTap: {
                                    showGameContent = false
                                },
                                isPressed: $isPressedLeading
                            )
                        )
                } label: {
                    EmptyView()
                }
            )
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isAnimating = true
                }
            }
        }
    }
    
    private func selectMode(_ mode: GameModeEnum) {
        selectedMode = mode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showGameContent = true
        }
    }
    
    @ViewBuilder
    private func makeGameContent() -> some View {
        switch game.type {
        case .quiz:
            GameQuiz()
        case .match:
            GameQuiz()
        case .swipe:
            GameQuiz()
        }
    }
}
