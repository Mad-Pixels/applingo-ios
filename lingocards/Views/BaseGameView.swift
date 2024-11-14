import SwiftUI

struct BaseGameView<Content: View>: View {
    @StateObject private var cacheGetter: GameCacheGetterViewModel
    @StateObject private var gameAction: GameActionViewModel
    
    @State private var scoreAnimations: [GameScoreAnimationModel] = []
    
    let isPresented: Binding<Bool>
    let content: Content
    let minimumWordsRequired: Int
    
    init(
        isPresented: Binding<Bool>,
        minimumWordsRequired: Int = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.minimumWordsRequired = minimumWordsRequired
        self.isPresented = isPresented
        self.content = content()
        
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let repository = RepositoryWord(dbQueue: dbQueue)
        self._cacheGetter = StateObject(wrappedValue: GameCacheGetterViewModel(repository: repository))
        self._gameAction = StateObject(wrappedValue: GameActionViewModel(repository: repository))
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    if gameAction.isGameActive {
                        CompToolbarGame(viewModel: gameAction)
                        Spacer()
                        Button(action: endGame) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(theme.secondaryIconColor)
                        }
                    }
                }
                .padding()
                
                if cacheGetter.isLoadingCache {
                    Spacer()
                    CompPreloaderView()
                    Spacer()
                } else if cacheGetter.cache.count < minimumWordsRequired {
                    Spacer()
                    CompGameStateView()
                    Spacer()
                } else if !gameAction.isGameActive {
                    Spacer()
                    GameModeView(
                        selectedMode: .init(
                            get: { gameAction.gameMode },
                            set: { mode in
                                gameAction.setGameMode(mode)
                            }
                        ),
                        startGame: {
                            gameAction.startGame()
                        }
                    )
                    Spacer()
                } else {
                    Spacer()
                    contentWithEnvironment
                        .environmentObject(cacheGetter)
                        .environmentObject(gameAction)
                    Spacer()
                }
            }
            if !scoreAnimations.isEmpty {
                VStack {
                    ForEach(scoreAnimations) { animation in
                        CompGameScorePointsView(score: animation)
                    }
                }
                .animation(.spring(), value: scoreAnimations)
                .zIndex(100)
            }
        }
        .onAppear {
            setupGame()
            setupScoreCallback()
        }
        .onDisappear(perform: cleanupGame)
    }
    
    private func setupGame() {
        FrameManager.shared.setActiveFrame(.game)
        cacheGetter.setFrame(.game)
        gameAction.setFrame(.game)
        cacheGetter.initializeCache()
    }
    
    private func setupScoreCallback() {
        gameAction.onScoreChange = { points, reason in
            showScoreAnimation(points, reason: reason)
        }
    }
    
    private func cleanupGame() {
        cacheGetter.clearCache()
        gameAction.endGame()
    }
    
    private func endGame() {
        cleanupGame()
        isPresented.wrappedValue = false
    }
    
    private func showScoreAnimation(_ points: Int, reason: ScoreAnimationReason = .normal) {
        let animation = GameScoreAnimationModel(points: points, reason: reason)
        withAnimation {
            scoreAnimations.append(animation)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                scoreAnimations.removeAll { $0.id == animation.id }
            }
        }
    }
    
    private var contentWithEnvironment: some View {
        content.environment(\.showScore) { points, reason in
            showScoreAnimation(points, reason: reason)
        }
    }
}

private struct ShowScoreKey: EnvironmentKey {
    static let defaultValue: ((Int, ScoreAnimationReason) -> Void)? = nil
}

extension EnvironmentValues {
    var showScore: ((Int, ScoreAnimationReason) -> Void)? {
        get { self[ShowScoreKey.self] }
        set { self[ShowScoreKey.self] = newValue }
    }
}
