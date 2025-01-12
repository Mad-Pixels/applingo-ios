import SwiftUI

struct LocaleTracker: ViewModifier {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: localeManager.currentLocale.asString))
            .onReceive(localeManager.objectWillChange) { _ in }
    }
}

extension View {
    func withLocaleTracker() -> some View {
        modifier(LocaleTracker())
    }
}
