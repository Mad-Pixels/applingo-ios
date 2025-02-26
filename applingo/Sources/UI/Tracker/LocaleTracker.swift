import SwiftUI

// MARK: - LocaleTracker ViewModifier
/// Applies the current locale to the view.
struct LocaleTracker: ViewModifier {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: localeManager.currentLocale.asString))
            .onReceive(localeManager.objectWillChange) { _ in }
    }
}

// Extension for easier usage of LocaleTracker
extension View {
    func withLocaleTracker() -> some View {
        modifier(LocaleTracker())
    }
}
