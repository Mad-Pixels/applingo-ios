import SwiftUI

struct ScoreAnimationModel: Identifiable, Equatable {
    let id = UUID()
    let points: Int
    let reason: ScoreAnimationReason
    
    static func == (lhs: ScoreAnimationModel, rhs: ScoreAnimationModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.points == rhs.points &&
        lhs.reason == rhs.reason
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

struct ScorePointsView: View {
    let score: ScoreAnimationModel
    let theme = ThemeManager.shared.currentThemeStyle
    
    var body: some View {
        HStack(spacing: 4) {
            if !score.reason.icon.isEmpty {
                Image(systemName: score.reason.icon)
                    .foregroundColor(score.reason.color)
            }
            
            Text(ScoreFormatter.formatScore(score.points, showPlus: true))
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(score.points >= 0 ? .green : .red)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            theme.backgroundBlockColor
                .opacity(0.9)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

struct BaseGameView<Content: View>: View {
    // MARK: - ViewModels
    @StateObject private var cacheGetter: GameCacheGetterViewModel
    @StateObject private var gameAction: GameActionViewModel
    
    // MARK: - State
    @State private var scoreAnimations: [ScoreAnimationModel] = []
    
    // MARK: - Properties
    let isPresented: Binding<Bool>
    let content: Content
    let minimumWordsRequired: Int
    
    // MARK: - Init
    init(
        isPresented: Binding<Bool>,
        minimumWordsRequired: Int = 12,
        @ViewBuilder content: () -> Content
    ) {
        print("🎮 BaseGameView: Initializing")
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
    
    // MARK: - Body
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    if gameAction.isGameActive {
                        CompToolbarGame(viewModel: gameAction)
                            //.environmentObject(gameAction)
                        
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
                                print("🎲 Setting game mode: \(mode)")
                                gameAction.setGameMode(mode)
                            }
                        ),
                        startGame: {
                            print("🎮 Starting game")
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
            
            // Score Animations Layer
            if !scoreAnimations.isEmpty {
                VStack {
                    ForEach(scoreAnimations) { animation in
                        ScorePointsView(score: animation)
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
    
    // MARK: - Setup
    private func setupGame() {
        print("🎮 BaseGameView: Setting up game")
        FrameManager.shared.setActiveFrame(.game)
        cacheGetter.setFrame(.game)
        gameAction.setFrame(.game)
        cacheGetter.initializeCache()
    }
    
    private func setupScoreCallback() {
        print("💯 BaseGameView: Setting up score callback")
        gameAction.onScoreChange = { points, reason in
            showScoreAnimation(points, reason: reason)
        }
    }
    
    // MARK: - Cleanup
    private func cleanupGame() {
        print("🧹 BaseGameView: Cleaning up game")
        cacheGetter.clearCache()
        gameAction.endGame()
    }
    
    private func endGame() {
        print("🎮 BaseGameView: Ending game")
        cleanupGame()
        isPresented.wrappedValue = false
    }
    
    private func showScoreAnimation(_ points: Int, reason: ScoreAnimationReason = .normal) {
        print("💫 Showing score animation: \(points) points, reason: \(reason)")
        let animation = ScoreAnimationModel(points: points, reason: reason)
        withAnimation {
            scoreAnimations.append(animation)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
