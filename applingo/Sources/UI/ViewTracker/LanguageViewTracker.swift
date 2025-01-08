import SwiftUI

struct LanguageViewTracker: ViewModifier {
    @ObservedObject private var languageManager = LanguageManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
    }
}

extension View {
    func withLanguageTracker() -> some View {
        modifier(LanguageViewTracker())
    }
}
