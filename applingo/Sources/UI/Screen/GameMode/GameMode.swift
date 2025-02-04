import SwiftUI

/// A view that displays the game mode selection screen.
/// Users can choose a mode (e.g. practice, survival, time attack) before starting the game.
struct GameMode: View {
    
    // MARK: - Properties
    
    /// The game instance conforming to AbstractGame protocol.
    let game: any AbstractGame
    
    /// Binding flag to control the presentation of the GameMode view.
    @Binding var isPresented: Bool
    
    /// Localization object for game mode texts.
    private let locale: GameModeLocale = GameModeLocale()
    
    @StateObject private var style: GameModeStyle
    @State private var selectedMode: GameModeType = .practice
    @State private var isPressedTrailing = false
    @State private var showGameContent = false
    @State private var isAnimating = false
    
    // MARK: - Initializer
    
    /// Initializes the GameMode view.
    /// - Parameters:
    ///   - game: The game instance.
    ///   - isPresented: Binding to control the view's presentation.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        game: any AbstractGame,
        isPresented: Binding<Bool>,
        style: GameModeStyle? = nil
    ) {
        self.game = game
        self._isPresented = isPresented
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle, gameTheme: game.theme)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .GameMode, alignment: .center) {
            ZStack {
                // Background view using a gradient or pattern defined in style.colors.
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
                // Animate the appearance of title and cards.
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isAnimating = true
                }
            }
            
            // Present game content when a mode is selected.
            if showGameContent {
                GameModeViewGame(
                    game: game,
                    mode: selectedMode,
                    showGameContent: $showGameContent
                )
            }
        }
    }
    
    // MARK: - Subviews
    
    /// The title view displaying the mode selection prompt.
    private var titleView: some View {
        Text(locale.screenTitle.uppercased())
            .font(style.titleStyle.font)
            .foregroundColor(style.titleStyle.color)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
    }
    
    /// A list of available game mode cards.
    private var modesListView: some View {
        VStack(spacing: style.cardSpacing) {
            ForEach(game.availableModes, id: \.self) { mode in
                modeCard(for: mode)
            }
        }
        .padding(.vertical, 24)
        .glassBackground()
    }
    
    // MARK: - Helper Methods
    
    /// Returns a card view for a given game mode.
    /// - Parameter mode: The game mode type.
    /// - Returns: A view representing the game mode card.
    private func modeCard(for mode: GameModeType) -> some View {
        let model = game.getModeModel(mode)
        return GameModeViewCard(
            mode: mode,
            icon: model.icon,
            title: model.title,
            description: model.description,
            style: game.theme,
            isSelected: selectedMode == mode,
            onSelect: { selectMode(mode) }
        )
        .padding(.horizontal, 16)
    }
    
    /// Handles the selection of a game mode.
    /// - Parameter mode: The selected game mode.
    private func selectMode(_ mode: GameModeType) {
        selectedMode = mode
        game.start(mode: mode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showGameContent = true
        }
    }
}
