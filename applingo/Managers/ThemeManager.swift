import Combine

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: DiscoverTheme {
        didSet {
            if Defaults.appTheme != currentTheme.rawValue {
                Defaults.appTheme = currentTheme.rawValue
            }
        }
    }
    
    private(set) var supportedThemes: [DiscoverTheme] = []
    
    init() {
        self.currentTheme = Self.getInitialTheme()
        self.supportedThemes = getSupportedThemes()
        Logger.debug("[ThemeManager]: Initialize manager with \(self.currentTheme.rawValue)")
    }
    
    private static func getInitialTheme() -> DiscoverTheme {
        return DiscoverTheme.fromString(Defaults.appTheme ?? DiscoverTheme.light.rawValue)
    }
    
    private func getSupportedThemes() -> [DiscoverTheme] {
        let themes = DiscoverTheme.allCases
        Logger.debug("[ThemeManager]: Supported themes: \(themes.map { $0.rawValue })")
        return themes
    }
    
    func setTheme(to theme: DiscoverTheme) {
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
