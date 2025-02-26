import Foundation

/// Provides localized strings for the Game Result view.
final class GameResultLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case timeUp = "game.result.timeUp"
        case noLives = "game.result.noLives"
        case gameOver = "game.result.gameOver"
        case close = "base.button.close"
        case playAgain = "base.button.again"
        case totalScore = "game.result.stats.totalScore"
        case accuracy = "game.result.stats.accuracy"
        case bestStreak = "game.result.stats.bestStreak"
        case totalAnswers = "game.result.stats.totalAnswers"
        case averageTime = "game.result.stats.averageTime"
    }
   
    // MARK: - Published Properties
    @Published private(set) var timeUpText: String
    @Published private(set) var noLivesText: String
    @Published private(set) var gameOverText: String
    @Published private(set) var closeButtonText: String
    @Published private(set) var playAgainButtonText: String
    @Published private(set) var totalScoreText: String
    @Published private(set) var accuracyText: String
    @Published private(set) var bestStreakText: String
    @Published private(set) var totalAnswersText: String
    @Published private(set) var averageTimeText: String
   
    // MARK: - Initialization
    init() {
        self.timeUpText = Self.localizedString(for: .timeUp)
        self.noLivesText = Self.localizedString(for: .noLives)
        self.gameOverText = Self.localizedString(for: .gameOver)
        self.closeButtonText = Self.localizedString(for: .close)
        self.playAgainButtonText = Self.localizedString(for: .playAgain)
        self.totalScoreText = Self.localizedString(for: .totalScore)
        self.accuracyText = Self.localizedString(for: .accuracy)
        self.bestStreakText = Self.localizedString(for: .bestStreak)
        self.totalAnswersText = Self.localizedString(for: .totalAnswers)
        self.averageTimeText = Self.localizedString(for: .averageTime)
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: LocaleManager.localeDidChangeNotification,
            object: nil
        )
    }
   
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    // MARK: - Localization Helper
    private static func localizedString(for key: LocalizedKey) -> String {
       return LocaleManager.shared.localizedString(for: key.rawValue)
    }
   
    // MARK: - Notification Handler
    @objc private func localeDidChange() {
        timeUpText = Self.localizedString(for: .timeUp)
        noLivesText = Self.localizedString(for: .noLives)
        gameOverText = Self.localizedString(for: .gameOver)
        closeButtonText = Self.localizedString(for: .close)
        playAgainButtonText = Self.localizedString(for: .playAgain)
        totalScoreText = Self.localizedString(for: .totalScore)
        accuracyText = Self.localizedString(for: .accuracy)
        bestStreakText = Self.localizedString(for: .bestStreak)
        totalAnswersText = Self.localizedString(for: .totalAnswers)
        averageTimeText = Self.localizedString(for: .averageTime)
    }
}
