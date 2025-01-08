import Combine

final class ThemeManager: ObservableObject {
    private(set) var supportedThemes: [ThemeType] = []
    static let shared = ThemeManager()
    
    @Published var currentTheme: ThemeType {
        didSet {
            if Defaults.appTheme != currentTheme.rawValue {
                Defaults.appTheme = currentTheme.rawValue
            }
        }
    }
    
    init() {
        self.currentTheme = Self.getInitialTheme()
        self.supportedThemes = getSupportedThemes()
        Logger.debug("[ThemeManager]: Initialize manager with \(self.currentTheme.rawValue)")
    }
    
    private static func getInitialTheme() -> ThemeType {
        return ThemeType.fromString(Defaults.appTheme ?? ThemeType.light.rawValue)
    }
    
    private func getSupportedThemes() -> [ThemeType] {
        let themes = ThemeType.allCases
        Logger.debug("[ThemeManager]: Supported themes: \(themes.map { $0.rawValue })")
        return themes
    }
    
    func setTheme(to theme: ThemeType) {
        self.currentTheme = theme
    }
    
    var currentThemeStyle: AppTheme {
        switch currentTheme {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }
}
