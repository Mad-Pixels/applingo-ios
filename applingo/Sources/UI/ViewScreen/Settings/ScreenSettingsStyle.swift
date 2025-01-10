import SwiftUI

struct ScreenSettingsStyle {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    let spacing: CGFloat
    let padding: EdgeInsets
    let backgroundColor: Color
    
    var navigationTitle: String {
        LocaleManager.shared.localizedString(for: "Settings").capitalizedFirstLetter
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
