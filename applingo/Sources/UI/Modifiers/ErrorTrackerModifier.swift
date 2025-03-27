import SwiftUI

/// A ViewModifier that displays an alert when an error occurs.
/// It observes the shared ErrorManager for any current errors and presents an alert
/// with the error's title, message (styled with the theme's error color), and an action button.
/// When the alert is dismissed, the current error is cleared and an optional error action is executed.
struct ErrorTrackerModifier: ViewModifier {
    @ObservedObject private var errorManager = ErrorManager.shared
    @EnvironmentObject private var themeManager: ThemeManager
    let screen: ScreenType

    func body(content: Content) -> some View {
        content
            .alert(item: $errorManager.currentError) { error in
                Alert(
                    title: Text(error.title),
                    message: Text(error.message)
                        .foregroundColor(themeManager.currentThemeStyle.errorPrimaryColor),
                    dismissButton: .default(Text(error.actionTitle ?? LocaleManager.shared.localizedString(for: "base.button.ok"))) {
                        errorManager.currentError = nil
                        error.action?()
                    }
                )
            }
    }
}
