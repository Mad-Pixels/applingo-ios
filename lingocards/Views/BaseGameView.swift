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
    @StateObject private var cacheGetter: GameCacheGetterViewModel
    @StateObject private var gameHandler: GameHandler
    @StateObject private var specialService = GameSpecialService()
    
    @State private var scoreAnimations: [ScoreAnimationModel] = []
    
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
        self._gameHandler = StateObject(wrappedValue: GameHandler(
            scoreCalculator: GameScoreCalculator(),
            onGameEnd: nil
        ))
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    if gameHandler.isGameActive {
                        CompToolbarGame()
                            .environmentObject(gameHandler)
                        
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
                } else if !gameHandler.isGameActive {
                    Spacer()
                    GameModeView(
                        selectedMode: .init(
                            get: { gameHandler.gameMode },
                            set: { mode in gameHandler.startGame(mode: mode) }
                        ),
                        startGame: { gameHandler.startGame(mode: .practice) }
                    )
                    Spacer()
                } else {
                    Spacer()
                    contentWithEnvironment
                        .environmentObject(cacheGetter)
                        .environmentObject(gameHandler)
                        .environmentObject(specialService)
                    Spacer()
                }
            }
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
    
    private func setupGame() {
        FrameManager.shared.setActiveFrame(.game)
        cacheGetter.setFrame(.game)
        cacheGetter.initializeCache()
    }
    
    private func setupScoreCallback() {
        gameHandler.onScoreChange = { points, reason in
            showScoreAnimation(points, reason: reason)
        }
    }

    private func cleanupGame() {
        cacheGetter.clearCache()
        gameHandler.endGame()
    }
    
    private func endGame() {
        cleanupGame()
        isPresented.wrappedValue = false
    }
    
    private func showScoreAnimation(_ points: Int, reason: ScoreAnimationReason = .normal) {
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

