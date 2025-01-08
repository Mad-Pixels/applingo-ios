import Combine

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: ThemeType {
        didSet {
            if Defaults.appTheme != currentTheme.rawValue {
                Defaults.appTheme = currentTheme.rawValue
            }
        }
    }
    
    private(set) var supportedThemes: [ThemeType] = []
    
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
    
    var currentThemeStyle: ThemeStyle {
        switch currentTheme {
        case .dark:
            return PaletteThemeDark()
        case .light:
            return PaletteThemeLight()
        }
    }
}
