import SwiftUI

struct SettingsFeedback: View {
    private let urlReport: String = "https://docs.madpixels.io/applingo/feedback"
    private let urlAbout: String = "https://docs.madpixels.io/applingo/about"
    
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var style: SettingsFeedbackStyle
    @StateObject private var locale = SettingsFeedbackLocale()
    
    @State private var isPressedLeading = false
    
    /// Initializes the SettingsFeedback.
    /// - Parameter style: Optional style; if nil, a themed style is applied.
    init(style: SettingsFeedbackStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .SettingsFeedback,
            title: locale.screenTitle
        ) {
            List {
                SettingsFeedbackViewLogger(
                    style: style,
                    locale: locale
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                
                SectionHeader(
                    title: locale.screenSubtitleUrls,
                    style: .block(themeManager.currentThemeStyle)
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .padding(.bottom, -12)
                
                SettingsFeedbackViewRedirect(
                    style: style,
                    locale: locale,
                    title: locale.screenButtonReport,
                    url: urlReport
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                
                SettingsFeedbackViewRedirect(
                    style: style,
                    locale: locale,
                    title: locale.screenButtonAbout,
                    url: urlAbout
                )
                .listRowBackground(Color.clear)
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        isPressed: $isPressedLeading,
                        onTap: {
                            AppStorage.shared.activeScreen = .Settings
                            dismiss()
                        },
                        style: .back(themeManager.currentThemeStyle)
                    )
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
