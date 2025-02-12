import SwiftUI

/// A view that displays the feedback screen in the Settings section.
struct SettingsFeedback: View {
    // MARK: - Constants
    private let urlAbout: String = "https://docs.madpixels.io/"
    private let urlReport: String = "https://docs.madpixels.io/"
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State Objects
    @StateObject private var style: SettingsFeedbackStyle
    @StateObject private var locale = SettingsFeedbackLocale()
    
    // MARK: - Local State
    @State private var isPressedLeading = false
    
    // MARK: - Initializer
    /// Initializes the SettingsFeedback view.
    /// - Parameter style: Optional style; if nil, a themed style is applied.
    init(style: SettingsFeedbackStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(screen: .SettingsFeedback, title: locale.screenTitle) {
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
                    style: .titled(ThemeManager.shared.currentThemeStyle)
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
