import SwiftUI

// Used in Base views.

/// A ViewModifier that applies the current locale to the view by injecting it into the environment.
/// The locale is obtained from the shared LocaleManager.
/// This ensures that all localized text in the view hierarchy uses the current locale settings.
struct TrackerLocaleModifier: ViewModifier {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: localeManager.currentLocale.asString))
            .onReceive(localeManager.objectWillChange) { _ in }
    }
}
