import Combine

/// A manager to handle application themes, providing support for theme switching and persistence.
final class ThemeManager: ObservableObject {
    // MARK: - Singleton Instance
    static let shared = ThemeManager()
    
    // MARK: - Properties
    /// List of supported themes.
    private(set) var supportedThemes: [ThemeType] = []
    
    /// Current selected theme. Updates AppStorage when changed.
    @Published var currentTheme: ThemeType {
        didSet {
            if AppStorage.shared.appTheme != currentTheme {
                AppStorage.shared.appTheme = currentTheme
            }
        }
    }
    
    // MARK: - Initialization
    /// Private initializer to enforce singleton pattern.
    private init() {
        self.currentTheme = Self.getInitialTheme()
        self.supportedThemes = getSupportedThemes()
        
        Logger.debug(
            "[Theme] Initialize manager",
            metadata: ["value": self.currentTheme.asString]
        )
    }
    
    // MARK: - Helpers
    /// Gets the initial theme from AppStorage.
    private static func getInitialTheme() -> ThemeType {
        AppStorage.shared.appTheme
    }
    
    /// Retrieves the list of supported themes.
    private func getSupportedThemes() -> [ThemeType] {
        let themes = ThemeType.allCases
        
        Logger.debug(
            "[Theme] supported values",
            metadata: ["list": "\(themes.map { $0.asString })"]
        )
        return themes
    }
    
    // MARK: - Theme Management
    /// Sets the theme and logs the change.
    /// - Parameter theme: The theme to be applied.
    func setTheme(to theme: ThemeType) {
        self.currentTheme = theme
        
        Logger.debug(
            "[Theme] update value",
            metadata: ["value": self.currentTheme.asString]
        )
    }
    
    /// Returns the current theme style.
    var currentThemeStyle: AppTheme {
        switch currentTheme {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }
}
