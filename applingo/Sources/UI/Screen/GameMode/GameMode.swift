import SwiftUI

struct GameMode: View {
    let game: GameType
    @Binding var isPresented: Bool
    
    private let locale: GameModeLocale = GameModeLocale()
    @StateObject private var style: GameModeStyle = .themed(ThemeManager.shared.currentThemeStyle)
    @State private var selectedMode: GameModeEnum = .practice
    @State private var showGameContent = false
    @State private var isAnimating = false
    
    var body: some View {
        BaseGameScreen(title: "Game Mode") {
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .background(
                NavigationLink(isActive: $showGameContent) {
                    makeGameContent()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(
                            leading: Button(action: { showGameContent = false }) {
                                Image(systemName: "chevron.left")
                            }
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
        switch game {
        case .quiz:
            GameQuiz()
        case .match:
            GameQuiz() // Заменить на GameMatch когда будет готов
        case .swipe:
            GameQuiz() // Заменить на GameSwipe когда будет готов
        }
    }
}
