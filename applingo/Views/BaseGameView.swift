import SwiftUI
import Combine

struct BaseGameView<Content: View>: View {    
    @StateObject private var cacheGetter: GameCacheGetterViewModel
    @StateObject private var gameAction: GameActionViewModel
    @StateObject private var cancellableStore = CancellableStore()
    
    @State private var scoreAnimations: [GameScoreAnimationModel] = []
    @State private var isInitialCacheLoaded = false
    @State private var showResultCard = false
    @State private var isRestarting = false
    
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

        self._cacheGetter = StateObject(wrappedValue: GameCacheGetterViewModel())
        self._gameAction = StateObject(wrappedValue: GameActionViewModel())
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    if gameAction.isGameActive {
                        CompToolbarGame(viewModel: gameAction)
                    }
                    Spacer()
                    Button(action: endGame) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(theme.cardBorder)
                    }
                }
                .padding()
                
                if !isInitialCacheLoaded {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if cacheGetter.cache.count < minimumWordsRequired {
                    Spacer()
                    CompGameEmptyView()
                    Spacer()
                } else if cacheGetter.cache.count >= minimumWordsRequired && !gameAction.isGameActive {
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
            if showResultCard {
                GameResultCardView(
                    stats: gameAction.stats,
                    gameMode: gameAction.gameMode,
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showResultCard = false
                            isPresented.wrappedValue = false
                            AppStorage.shared.activeScreen = .game
                        }
                    },
                    onRestart: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showResultCard = false
                            restartGame()
                        }
                    }
                )
                .zIndex(200)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .onAppear {
            setupGame()
            setupScoreCallback()
            setupGameOverCallback()
            
            if !isInitialCacheLoaded {
                cacheGetter.$isLoadingCache
                    .filter { !$0 }
                    .first()
                    .sink { _ in
                        withAnimation {
                            isInitialCacheLoaded = true
                        }
                    }
                    .store(in: &cancellableStore.cancellables)
            }
        }
        .onDisappear(perform: cleanupGame)
    }
    
    private func handleGameEnd() {
            if gameAction.gameMode == .practice {
                cleanupGame()
                isPresented.wrappedValue = false
            } else {
                showGameResults()
            }
        }
    
    private func setupGame() {
        AppStorage.shared.activeScreen = .game
        cacheGetter.setFrame(.game)
        gameAction.setFrame(.game)
        cacheGetter.initializeCache()
    }
    
    private func setupScoreCallback() {
        gameAction.onScoreChange = { points, reason in
            showScoreAnimation(points, reason: reason)
        }
    }
    private func restartGame() {
        isRestarting = true
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showResultCard = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cleanupGame()
            setupGame()
            setupGameOverCallback()
            gameAction.startGame()
            isRestarting = false
        }
    }
    
    private func showGameResults() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showResultCard = true
        }
    }
    
    private func setupGameOverCallback() {
        cancellableStore.cancellables.removeAll()
        
        gameAction.$isGameActive.sink { isActive in
            if !isActive && !showResultCard && !isRestarting &&
               (gameAction.gameMode == .timeAttack || gameAction.gameMode == .survival) {
                showGameResults()
            }
        }
        .store(in: &cancellableStore.cancellables)
    }
    
    private func cleanupGame() {
        isInitialCacheLoaded = false
        cancellableStore.cancellables.removeAll()
        cacheGetter.clearCache()
        gameAction.endGame()
    }
    
    private func endGame() {
        if !isRestarting {
            cleanupGame()
            isPresented.wrappedValue = false
            AppStorage.shared.activeScreen = .game
        }
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

private struct ShowResultCardKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var showResultCard: (() -> Void)? {
        get { self[ShowResultCardKey.self] }
        set { self[ShowResultCardKey.self] = newValue }
    }
}

class CancellableStore: ObservableObject {
    var cancellables = Set<AnyCancellable>()
}

struct AnswerFeedback: View {
    let isCorrect: Bool
    let isSpecial: Bool
    
    var body: some View {
        if isSpecial && isCorrect {
            Image(systemName: "star.circle.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 80))
                .transition(.scale.combined(with: .opacity))
        } else {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.clear)
                .transition(.scale.combined(with: .opacity))
        }
    }
}
