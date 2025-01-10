import SwiftUI

struct ErrorViewTracker: ViewModifier {
    @ObservedObject private var errorManager = ErrorManager.shared
    @EnvironmentObject private var themeManager: ThemeManager
    let screen: ScreenType
    
    func body(content: Content) -> some View {
        content
            .alert(
                "error.title",
                isPresented: Binding(
                    get: { errorManager.currentError != nil },
                    set: { if !$0 { errorManager.currentError = nil } }
                ),
                presenting: errorManager.currentError
            ) { error in
                Button(
                    error.actionTitle ?? LocaleManager.shared.localizedString(for: "general.ok"),
                    action: error.action ?? {}
                )
            } message: { error in
                Text(error.message)
                    .foregroundColor(themeManager.currentThemeStyle.errorPrimaryColor)
            }
    }
}

extension View {
    func withErrorTracker(_ screen: ScreenType) -> some View {
        modifier(ErrorViewTracker(screen: screen))
    }
}
