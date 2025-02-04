import SwiftUI

/// A view that displays the settings screen.
/// It contains sections for theme, language and feedback.
struct Settings: View {
    
    // MARK: - State Objects
    
    /// Style configuration for the settings screen.
    @StateObject private var style: SettingsStyle
    /// Localization object for settings texts.
    @StateObject private var locale = SettingsLocale()
    
    // MARK: - Initializer
    
    /// Initializes the Settings view.
    /// - Parameter style: Optional style; if nil, a themed style is applied.
    init(style: SettingsStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .Settings, title: locale.screenTitle) {
            List {
                SettingsViewTheme()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: style.padding.top + 8,
                        leading: style.padding.leading + 8,
                        bottom: 0,
                        trailing: style.padding.trailing + 8
                    ))
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                
                SettingsViewLocale()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: style.spacing,
                        leading: style.padding.leading + 8,
                        bottom: 0,
                        trailing: style.padding.trailing + 8
                    ))
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                
                SettingsViewFeedback()
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
