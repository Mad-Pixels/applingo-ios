import Combine

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    private(set) var supportedThemes: [ThemeType] = []
    
    @Published var currentTheme: ThemeType {
        didSet {
            if AppStorage.shared.appTheme != currentTheme {
                AppStorage.shared.appTheme = currentTheme
            }
        }
    }
    
    private init() {
        self.currentTheme = Self.getInitialTheme()
        self.supportedThemes = getSupportedThemes()
        Logger.debug("[ThemeManager]: Initialize manager with \(self.currentTheme.asString)")
    }
    
    private static func getInitialTheme() -> ThemeType {
        AppStorage.shared.appTheme
    }
    
    private func getSupportedThemes() -> [ThemeType] {
        let themes = ThemeType.allCases
        Logger.debug("[ThemeManager]: Supported themes: \(themes.map { $0.asString })")
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
