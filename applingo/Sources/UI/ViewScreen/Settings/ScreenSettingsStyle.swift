import SwiftUI

struct ScreenSettingsStyle {
    let spacing: CGFloat
    let padding: EdgeInsets
    let backgroundColor: Color
    let navigationTitle: String
}

extension ScreenSettingsStyle {
    static func themed(_ theme: AppTheme) -> ScreenSettingsStyle {
        ScreenSettingsStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary,
            navigationTitle: LocaleManager.shared.localizedString(for: "settings").capitalizedFirstLetter
        )
    }
}
