import SwiftUI

struct Settings: View {
    @StateObject private var style: SettingsStyle
    @StateObject private var locale = SettingsLocale()
    
    /// Initializes the WordDetails.
    /// - Parameters:
    ///   - style: Optional style; if nil, a themed style is applied.
    init(style: SettingsStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .Settings,
            title: locale.screenTitle
        ) {
            List {
                SettingsViewTheme(
                    style: style,
                    locale: locale
                )
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: style.padding.top + 8,
                        leading: style.padding.leading + 8,
                        bottom: 0,
                        trailing: style.padding.trailing + 8
                    ))
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                
                SettingsViewLocale(
                    style: style,
                    locale: locale
                )
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: style.spacing,
                        leading: style.padding.leading + 8,
                        bottom: 0,
                        trailing: style.padding.trailing + 8
                    ))
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                
                SettingsViewFeedback(
                    style: style,
                    locale: locale
                )
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: style.spacing,
                        leading: style.padding.leading + 8,
                        bottom: 0,
                        trailing: style.padding.trailing + 8
                    ))
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
            }
            .listStyle(.plain)
            .background(style.backgroundColor)
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
            .navigationTitle(locale.screenTitle)
            .navigationBarTitleDisplayMode(.large)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
