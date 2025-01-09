import SwiftUI

struct LocaleViewTracker: ViewModifier {
    @ObservedObject private var localeManager = LocaleManager.shared
    
    func body(content: Content) -> some View {
        content
            .id(localeManager.viewId)
            .environment(\.locale, .init(identifier: localeManager.currentLocale.asString))
            .onReceive(NotificationCenter.default.publisher(for: LocaleManager.localeDidChangeNotification)) { _ in
                Logger.debug("[LocaleViewTracker]: Received locale change notification")
            }
    }
}

extension View {
    func withLocaleTracker() -> some View {
        modifier(LocaleViewTracker())
    }
}
