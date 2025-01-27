import SwiftUI

struct Settings: View {
    @StateObject private var style: SettingsStyle
    @StateObject private var locale = SettingsLocale()

    init(style: SettingsStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }

    var body: some View {
        BaseScreen(
            screen: .Settings,
            title: locale.navigationTitle
        ) {
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
                
                SettingsViewLogger()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: style.spacing,
                        leading: style.padding.leading + 8,
                        bottom: style.padding.bottom,
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
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
