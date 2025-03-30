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
            ScrollView {
                VStack(spacing: style.spacing) {
                    SettingsFeedbackViewLogger(
                        style: style,
                        locale: locale
                    )
                    
                    VStack(spacing: style.spacing) {
                        SectionHeader(
                            title: locale.screenSubtitleUrls,
                            style: .block(themeManager.currentThemeStyle)
                        )
                        .padding(.top, 8)
                        
                        VStack(spacing: style.spacing) {
                            SettingsFeedbackViewRedirect(
                                style: style,
                                locale: locale,
                                title: locale.screenButtonReport,
                                url: urlReport
                            )
                            
                            SettingsFeedbackViewRedirect(
                                style: style,
                                locale: locale,
                                title: locale.screenButtonAbout,
                                url: urlAbout
                            )
                        }
                        .padding(.horizontal, 8)
                        .background(Color.clear)
                    }
                }
                .padding(style.padding)
            }
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
        }
    }
}
