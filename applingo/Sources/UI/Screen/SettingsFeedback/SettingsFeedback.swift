import SwiftUI

/// A view that displays the feedback screen in the Settings section.
/// It shows log-related options (например, отправку логов) и предоставляет возможность возврата к настройкам.
struct SettingsFeedback: View {
    
    // MARK: - Environment and State Properties
    
    /// Provides a dismiss action to close the current view.
    @Environment(\.dismiss) private var dismiss
    
    /// Style configuration for the feedback screen.
    @StateObject private var style: SettingsFeedbackStyle
    
    /// Localization object for feedback texts.
    @StateObject private var locale = SettingsLocale()  // Можно использовать отдельный SettingsFeedbackLocale, если требуется отдельная локализация.
    
    /// Flag for back button animation.
    @State private var isPressedLeading = false
    
    // MARK: - Initializer
    
    /// Initializes the SettingsFeedback view.
    /// - Parameter style: Optional style; if nil, a themed style is applied.
    init(style: SettingsFeedbackStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .SettingsFeedback, title: locale.navigationTitle) {
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
