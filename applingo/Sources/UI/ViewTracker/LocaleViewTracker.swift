import SwiftUI

struct LocaleViewTracker: ViewModifier {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: localeManager.currentLocale.asString))
            .onReceive(localeManager.objectWillChange) { _ in
                Logger.debug("[LocaleViewTracker]: Locale environment updated to: \(localeManager.currentLocale.asString)")
            }
    }
}

extension View {
    func withLocaleTracker() -> some View {
        modifier(LocaleViewTracker())
    }
}
