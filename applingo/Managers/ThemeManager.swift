import Combine

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: DisplayTheme {
        didSet {
            if Defaults.appTheme != currentTheme.rawValue {
                Defaults.appTheme = currentTheme.rawValue
            }
        }
    }
    
    private(set) var supportedThemes: [DisplayTheme] = []
    
    init() {
        self.currentTheme = Self.getInitialTheme()
        self.supportedThemes = getSupportedThemes()
        Logger.debug("[ThemeManager]: Initialize manager with \(self.currentTheme.rawValue)")
    }
    
    private static func getInitialTheme() -> DisplayTheme {
        return DisplayTheme.fromString(Defaults.appTheme ?? DisplayTheme.light.rawValue)
    }
    
    private func getSupportedThemes() -> [DisplayTheme] {
        let themes = DisplayTheme.allCases
        Logger.debug("[ThemeManager]: Supported themes: \(themes.map { $0.rawValue })")
        return themes
    }
    
    func setTheme(to theme: DisplayTheme) {
        self.currentTheme = theme
    }
    
    var currentThemeStyle: AppTheme {
        switch currentTheme {
        case .dark:
            return PaletteThemeDark()
        case .light:
            return PaletteThemeLight()
        }
    }
}
