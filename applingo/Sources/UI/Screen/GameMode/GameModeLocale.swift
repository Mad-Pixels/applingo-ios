import Foundation

/// Provides localized strings for the GameMode view.
final class GameModeLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let selectGameMode = "SelectGameMode"
        static let gamePractice = "GamePractice"
        static let gameSurvival = "GameSurvival"
        static let gameTimeAttack = "GameTimeAttack"
        static let practiceDescription = "PracticeDescription"
        static let survivalDescription = "SurvivalDescription"
        static let timeAttackDescription = "TimeAttackDescription"
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var selectModeTitle: String
    @Published private(set) var practiceTitle: String
    @Published private(set) var survivalTitle: String
    @Published private(set) var timeAttackTitle: String
    @Published private(set) var practiceDescription: String
    @Published private(set) var survivalDescription: String
    @Published private(set) var timeAttackDescription: String
    
    // MARK: - Initialization
    
    init() {
        self.selectModeTitle = Self.localizedString(for: .selectModeTitle)
        self.practiceTitle = Self.localizedString(for: .practiceTitle)
        self.survivalTitle = Self.localizedString(for: .survivalTitle)
        self.timeAttackTitle = Self.localizedString(for: .timeAttackTitle)
        self.practiceDescription = Self.localizedString(for: .practiceDescription)
        self.survivalDescription = Self.localizedString(for: .survivalDescription)
        self.timeAttackDescription = Self.localizedString(for: .timeAttackDescription)
        
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
    
    private enum LocalizedKey {
        case selectModeTitle, practiceTitle, survivalTitle, timeAttackTitle
        case practiceDescription, survivalDescription, timeAttackDescription
        
        var key: String {
            switch self {
            case .selectModeTitle: return Strings.selectGameMode
            case .practiceTitle: return Strings.gamePractice
            case .survivalTitle: return Strings.gameSurvival
            case .timeAttackTitle: return Strings.gameTimeAttack
            case .practiceDescription: return Strings.practiceDescription
            case .survivalDescription: return Strings.survivalDescription
            case .timeAttackDescription: return Strings.timeAttackDescription
            }
        }
        
        var capitalized: Bool {
            true
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        selectModeTitle = Self.localizedString(for: .selectModeTitle)
        practiceTitle = Self.localizedString(for: .practiceTitle)
        survivalTitle = Self.localizedString(for: .survivalTitle)
        timeAttackTitle = Self.localizedString(for: .timeAttackTitle)
        practiceDescription = Self.localizedString(for: .practiceDescription)
        survivalDescription = Self.localizedString(for: .survivalDescription)
        timeAttackDescription = Self.localizedString(for: .timeAttackDescription)
    }
}
