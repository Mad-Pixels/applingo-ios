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

enum ScoreAnimationReason: Equatable {
    case normal
    case fast
    case special
    case hint
    
    var icon: String {
        switch self {
        case .normal: return ""
        case .fast: return "bolt.fill"
        case .special: return "star.fill"
        case .hint: return "lightbulb.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .normal: return .primary
        case .fast: return .blue
        case .special: return .yellow
        case .hint: return .orange
        }
    }
}

// MARK: - Environment Key
private struct BaseGameViewKey: EnvironmentKey {
    static let defaultValue: ((Int, ScoreAnimationReason) -> Void)? = nil
}

extension EnvironmentValues {
    var showScore: ((Int, ScoreAnimationReason) -> Void)? {
        get { self[BaseGameViewKey.self] }
        set { self[BaseGameViewKey.self] = newValue }
    }
}

// MARK: - Score Points View
struct ScorePointsView: View {
    let score: ScoreAnimationModel
    let theme = ThemeManager.shared.currentThemeStyle
    
    var body: some View {
        HStack(spacing: 4) {
            if !score.reason.icon.isEmpty {
                Image(systemName: score.reason.icon)
                    .foregroundColor(score.reason.color)
            }
            
            Text(score.points > 0 ? "+\(score.points)" : "\(score.points)")
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

// MARK: - Base Game View
struct BaseGameView<Content: View>: View {
    @StateObject private var cacheGetter: GameCacheGetterViewModel
    @StateObject private var gameAction: GameActionViewModel
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
        self._gameAction = StateObject(wrappedValue: GameActionViewModel(repository: repository))
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    if gameAction.isGameActive {
                        CompToolbarGame(
                            gameMode: gameAction.gameMode,
                            stats: gameAction.stats,
                            isGameActive: .constant(true)
                        )
                    }
                    Spacer()
                    Button(action: {
                        cacheGetter.clearCache()
                        gameAction.endGame()
                        isPresented.wrappedValue = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(theme.secondaryIconColor)
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
                            set: { newMode in
                                gameAction.setGameMode(newMode)
                            }
                        ),
                        startGame: { gameAction.startGame() }
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
                        ScorePointsView(score: animation)
                    }
                }
                .animation(.spring(), value: scoreAnimations)
                .zIndex(100)
            }
        }
        .onAppear {
            FrameManager.shared.setActiveFrame(.game)
            cacheGetter.setFrame(.game)
            gameAction.setFrame(.game)
            cacheGetter.initializeCache()
        }
        .onDisappear {
            cacheGetter.clearCache()
            gameAction.endGame()
        }
    }
    
    func showScoreAnimation(_ points: Int, reason: ScoreAnimationReason = .normal) {
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
    
    var contentWithEnvironment: some View {
        content.environment(\.showScore) { points, reason in
            showScoreAnimation(points, reason: reason)
        }
    }
}


///
///
///
///
///
///
///
///
///


// MARK: - Score Calculator
struct GameScoreCalculator {
    struct ScoreResult {
        let baseScore: Int
        let timeBonus: Int
        let streakBonus: Int
        let specialBonus: Int
        let totalScore: Int
        let reason: ScoreAnimationReason
        
        var isPositive: Bool {
            totalScore > 0
        }
    }
    
    static func calculateScore(
        isCorrect: Bool,
        streak: Int,
        responseTime: TimeInterval,
        isSpecial: Bool
    ) -> ScoreResult {
        guard isCorrect else {
            return ScoreResult(
                baseScore: -10,
                timeBonus: 0,
                streakBonus: 0,
                specialBonus: 0,
                totalScore: -10,
                reason: .normal
            )
        }
        
        // Базовые очки
        let baseScore = 10
        
        // Бонус за время
        let timeBonus = max(5 * (1.0 - responseTime/3.0), 1)
        
        // Бонус за серию
        let streakMultiplier = min(Double(streak) * 0.1 + 1.0, 2.0)
        let streakBonus = Int(Double(baseScore) * (streakMultiplier - 1.0))
        
        // Бонус за специальную карточку
        let specialMultiplier: Double = isSpecial ? 2.5 : 1.0
        let specialBonus = isSpecial ?
            Int(Double(baseScore + Int(timeBonus) + streakBonus) * (specialMultiplier - 1.0)) : 0
        
        // Итоговые очки
        let totalScore = baseScore + Int(timeBonus) + streakBonus + specialBonus
        
        // Определяем причину для анимации
        let reason: ScoreAnimationReason
        if isSpecial {
            reason = .special
        } else if responseTime < 1.0 {
            reason = .fast
        } else {
            reason = .normal
        }
        
        return ScoreResult(
            baseScore: baseScore,
            timeBonus: Int(timeBonus),
            streakBonus: streakBonus,
            specialBonus: specialBonus,
            totalScore: totalScore,
            reason: reason
        )
    }
}

// MARK: - Game Stats Extension
extension GameStatsModel {
    mutating func updateStats(
        isCorrect: Bool,
        responseTime: TimeInterval,
        isSpecial: Bool = false
    ) {
        if isCorrect {
            correctAnswers += 1
            streak += 1
            bestStreak = max(bestStreak, streak)
            
            let scoreResult = GameScoreCalculator.calculateScore(
                isCorrect: true,
                streak: streak,
                responseTime: responseTime,
                isSpecial: isSpecial
            )
            score += scoreResult.totalScore
        } else {
            wrongAnswers += 1
            streak = 0
            lives -= 1
            score -= 10
        }
        
        let totalAnswers = correctAnswers + wrongAnswers
        averageResponseTime = (averageResponseTime * Double(totalAnswers - 1) + responseTime) / Double(totalAnswers)
    }
}

