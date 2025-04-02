import SwiftUI

struct GameMode<GameType: AbstractGame>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var style: GameModeStyle
    @StateObject private var locale: GameModeLocale = GameModeLocale()
    
    @State private var isPressedTrailing = false
    @State private var showGameContent = false
    @State private var isAnimating = false
    @State private var currentTab = 0
    
    @Binding var isPresented: Bool
    
    let game: GameType
    
    /// Initializes the GameMode.
    /// - Parameters:
    ///   - game: The game instance.
    ///   - isPresented: Binding to control the view's presentation.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        game: GameType,
        isPresented: Binding<Bool>,
        style: GameModeStyle? = nil
    ) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle, gameTheme: game.theme))
        _isPresented = isPresented
        self.game = game
    }
    
    var body: some View {
        BaseScreen(
            screen: .GameMode,
            alignment: .center
        ) {
            if showGameContent {
                GameModeViewGame(
                    game: game,
                    showGameContent: $showGameContent,
                    isPressedTrailing: $isPressedTrailing,
                    isPresented: $isPresented
                )
            } else {
                modeSelectionContent
            }
        }
    }
    
    private var modeSelectionContent: some View {
        ZStack {
            BackgroundGameMode(colors: style.colors)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                TabView(selection: $currentTab) {
                    tabContent(
                        title: locale.screenTitle.uppercased(),
                        content: {
                            ForEach(game.availableModes, id: \.self) { mode in
                                modeCard(for: mode)
                            }
                        }
                    )
                    .tag(0)
                    
                    if game.settings.hasSettings {
                        tabContent(
                            title: locale.screenTitleSettings.uppercased(),
                            content: {
                                GameModeViewSettings(settings: game.settings)
                                    .padding(.horizontal, 16)
                            }
                        )
                        .tag(1)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            .padding(style.padding)
        }
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ButtonNav(
                    isPressed: $isPressedTrailing,
                    onTap: { isPresented = false },
                    style: .close(ThemeManager.shared.currentThemeStyle)
                )
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    @ViewBuilder
    private func tabContent<Content: View>(title: String, content: () -> Content) -> some View {
        VStack(spacing: style.cardSpacing) {
            Text(title)
                .font(style.titleStyle.font)
                .foregroundColor(style.titleStyle.color)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            
            content()
        }
        .padding(.vertical, 24)
        .glassBackground()
        .padding(.horizontal, 6)
    }
    
    /// Returns a card view for a given game mode.
    /// - Parameter mode: The game mode type.
    /// - Returns: A view representing the game mode card.
    private func modeCard(for mode: GameModeType) -> some View {
        let model = game.getModeModel(mode)
        return GameModeViewCard(
            locale: locale,
            style: game.theme,
            mode: mode,
            icon: model.icon,
            title: model.title,
            description: model.description,
            onSelect: {
                game.state.initialize(for: mode)
                showGameContent = true
            }
        )
        .padding(.horizontal, 16)
    }
}
