import SwiftUI

struct SettingsFeedback: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var style: SettingsFeedbackStyle
    @StateObject private var locale = SettingsLocale()
    @State private var isPressedLeading = false

    init(style: SettingsFeedbackStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }

    var body: some View {
        BaseScreen(
            screen: .SettingsFeedback,
            title: locale.navigationTitle
        ) {
            List {
                SettingsFeedbackViewLogger()
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        style: .back(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            AppStorage.shared.activeScreen = .Settings
                            dismiss()
                        },
                        isPressed: $isPressedLeading
                    )
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
