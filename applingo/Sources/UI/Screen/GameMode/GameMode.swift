import SwiftUI

struct GameMode: View {
    @Binding var isCoverPresented: Bool
    let gameType: GameType
    @Binding var selectedMode: GameModeEnum
    @Binding var showGameContent: Bool
    
    @StateObject private var style: GameModeStyle = .themed(ThemeManager.shared.currentThemeStyle)
    private let locale: GameModeLocale = GameModeLocale()
    @State private var isAnimating = false
    
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
        .navigationBarTitle("Game Mode", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isCoverPresented = false
                }) {
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

    private func selectMode(_ mode: GameModeEnum) {
        selectedMode = mode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showGameContent = true
        }
    }
    
    @ViewBuilder
    private func makeGameContent() -> some View {
        switch gameType {
        case .quiz:
            GameQuiz()
        case .match:
            GameQuiz() // Замените на GameMatch() когда будет реализован
        case .swipe:
            GameQuiz() // Замените на GameSwipe() когда будет реализован
        }
    }
}
