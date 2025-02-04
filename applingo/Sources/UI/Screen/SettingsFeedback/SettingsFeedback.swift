import SwiftUI

/// A view that displays the feedback screen in the Settings section.
struct SettingsFeedback: View {
    
    // MARK: - Environment and State Properties
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var style: SettingsFeedbackStyle
    @StateObject private var locale = SettingsFeedbackLocale()
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
        BaseScreen(screen: .SettingsFeedback, title: locale.screenTitle) {
            List {
                SettingsFeedbackViewLogger(style: style)
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
