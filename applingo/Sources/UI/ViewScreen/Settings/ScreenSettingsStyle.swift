import SwiftUI

final class ScreenSettingsStyle: ObservableObject {
    private enum Strings {
        static let settings = "Settings"
    }
    
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    @Published private(set) var navigationTitle: String
    
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        
        self.navigationTitle = LocaleManager.shared.localizedString(for: Strings.settings).capitalizedFirstLetter
        
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
    
    @objc private func localeDidChange() {
        navigationTitle = LocaleManager.shared.localizedString(for: Strings.settings).capitalizedFirstLetter
    }
}

extension ScreenSettingsStyle {
    static func themed(_ theme: AppTheme) -> ScreenSettingsStyle {
        ScreenSettingsStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
