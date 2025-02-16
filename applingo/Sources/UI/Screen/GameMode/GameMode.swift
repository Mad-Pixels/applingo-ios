import SwiftUI

/// A view that displays the game mode selection screen.
/// Users can choose a mode (e.g. practice, survival, time attack) before starting the game.
struct GameMode: View {
    // MARK: - Properties
    let game: any AbstractGame
    
    // MARK: - State Objects
    @StateObject private var style: GameModeStyle
    @StateObject private var locale: GameModeLocale = GameModeLocale()
    @Binding var isPresented: Bool
    
    // MARK: - Local State
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
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle, gameTheme: game.theme))
        _isPresented = isPresented
        self.game = game
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(
            screen: .GameMode,
            alignment: .center
        ) {
            if showGameContent {
                GameModeViewGame(
                    game: game,
                    mode: selectedMode,
                    showGameContent: $showGameContent,
                    isPressedTrailing: $isPressedTrailing,
                    isPresented: $isPresented
                )
            } else {
                modeSelectionContent
            }
        }
    }
    
    // MARK: - Private Views
    private var modeSelectionContent: some View {
        ZStack {
            GameModeBackground(style.colors)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: style.spacing) {
                Text(locale.screenTitle.uppercased())
                    .font(style.titleStyle.font)
                    .foregroundColor(style.titleStyle.color)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                VStack(spacing: style.cardSpacing) {
                    ForEach(game.availableModes, id: \.self) { mode in
                        modeCard(for: mode)
                    }
                }
                .padding(.vertical, 24)
                .glassBackground()
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
    }
    
    // MARK: - Private Methods
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
            isSelected: selectedMode == mode,
            onSelect: {
                showGameContent = true
                selectedMode = mode
            }
        )
        .padding(.horizontal, 16)
    }
}

