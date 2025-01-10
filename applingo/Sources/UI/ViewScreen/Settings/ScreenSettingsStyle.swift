import SwiftUI

final class ScreenSettingsStyle: ObservableObject {
    let spacing: CGFloat
    let padding: EdgeInsets
    let backgroundColor: Color
    
    @Published private(set) var navigationTitle: String
    
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color,
        navigationTitle: String
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.navigationTitle = navigationTitle
        
        // Подписываемся на смену локали
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
        // Обновляем заголовок при смене локали
        navigationTitle = LocaleManager.shared.localizedString(for: "Settings").capitalizedFirstLetter
    }
}

extension ScreenSettingsStyle {
    static func themed(_ theme: AppTheme) -> ScreenSettingsStyle {
        ScreenSettingsStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary,
            navigationTitle: LocaleManager.shared.localizedString(for: "Settings").capitalizedFirstLetter
        )
    }
}
