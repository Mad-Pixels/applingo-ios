import Foundation

/// Provides localized strings for the Game Result view.
final class GameResultLocale: ObservableObject {
   // MARK: - Localized Keys
   private enum LocalizedKey: String {
       case timeUp = "game.result.timeUp"
       case noLives = "game.result.noLives"
       case gameOver = "game.result.gameOver"
       case close = "game.result.close"
       case playAgain = "game.result.playAgain"
   }
   
   // MARK: - Published Properties
   @Published private(set) var timeUpText: String
   @Published private(set) var noLivesText: String
   @Published private(set) var gameOverText: String
   @Published private(set) var closeButtonText: String
   @Published private(set) var playAgainButtonText: String
   
   // MARK: - Initialization
   init() {
       self.timeUpText = Self.localizedString(for: .timeUp)
       self.noLivesText = Self.localizedString(for: .noLives)
       self.gameOverText = Self.localizedString(for: .gameOver)
       self.closeButtonText = Self.localizedString(for: .close)
       self.playAgainButtonText = Self.localizedString(for: .playAgain)
       
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
   }
}
