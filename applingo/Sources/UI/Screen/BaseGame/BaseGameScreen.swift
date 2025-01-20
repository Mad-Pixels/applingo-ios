import SwiftUI

struct BaseGameScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseGameScreenStyle
    private let content: Content
    private let title: String
    
    init(
        title: String,
        style: BaseGameScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.title = title
    }
    
    var body: some View {
        NavigationView {
            content
                .id("\(themeManager.currentTheme.rawValue)_\(localeManager.viewId)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(title)
        }
        .navigationViewStyle(.stack)
        .navigationBarColor(color: .clear)
    }
}
