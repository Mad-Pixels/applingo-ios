import SwiftUI

// MARK: - ErrorTracker ViewModifier
/// Displays an alert when an error occurs.
struct ErrorTracker: ViewModifier {
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
                    dismissButton: .default(Text(error.actionTitle ?? LocaleManager.shared.localizedString(for: "general.ok"))) {
                        errorManager.currentError = nil
                        error.action?()
                    }
                )
            }
    }
}

// Extension for easier usage of ErrorTracker
extension View {
    func withErrorTracker(_ screen: ScreenType) -> some View {
        modifier(ErrorTracker(screen: screen))
    }
}
