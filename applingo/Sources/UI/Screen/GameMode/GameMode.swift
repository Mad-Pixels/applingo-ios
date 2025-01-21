import SwiftUI

struct GameMode: View {
    let game: any AbstractGame
    @Binding var isPresented: Bool
    private let locale: GameModeLocale = GameModeLocale()
    @StateObject private var style: GameModeStyle
    @State private var selectedMode: GameModeType = .practice
    @State private var isPressedTrailing = false
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
        BaseScreen(screen: .game, alignment: .center) {
            ZStack {
                GameModeBackground(style.colors)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: style.spacing) {
                    titleView
                    modesListView
                }
                .padding(style.padding)
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .close(ThemeManager.shared.currentThemeStyle),
                        onTap: { isPresented = false },
                        isPressed: $isPressedTrailing
                    )
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isAnimating = true
                }
            }
            if showGameContent {
                GameModeViewGame(
                    game: game,
                    mode: selectedMode,
                    showGameContent: $showGameContent
                )
            }
        }
    }
    
    private var titleView: some View {
        Text(locale.selectModeTitle.uppercased())
            .font(style.titleStyle.font)
            .foregroundColor(style.titleStyle.color)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
    }
    
    private var modesListView: some View {
        VStack(spacing: style.cardSpacing) {
            ForEach(game.availableModes, id: \.self) { mode in
                modeCard(for: mode)
            }
        }
        .padding(.vertical, 24)
        .glassBackground()
    }
    
    private func modeCard(for mode: GameModeType) -> some View {
        let model = game.getModeModel(mode)
        return GameModeViewCard(
            mode: mode,
            icon: model.icon,
            title: model.title,
            description: model.description,
            style: style,
            isSelected: selectedMode == mode,
            onSelect: { selectMode(mode) }
        )
        .padding(.horizontal, 16)
    }
    
    private func selectMode(_ mode: GameModeType) {
        selectedMode = mode
        game.state.currentMode = mode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showGameContent = true
        }
    }
}
