import SwiftUI

struct LocaleViewTracker: ViewModifier {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: localeManager.currentLocale.asString))
    }
}

extension View {
    func withLocaleTracker() -> some View {
        modifier(LocaleViewTracker())
    }
}
