import SwiftUI

// MARK: - ItemToggle View
/// A toggle component with an optional header and custom styling.
struct ItemToggle: View {
    @Binding var isOn: Bool
    let title: String
    let header: String?
    let style: ItemToggleStyle
    let onChange: ((Bool) -> Void)?
    
    /// Initializes the toggle.
    /// - Parameters:
    ///   - isOn: Binding to the toggle state.
    ///   - title: The title of the toggle.
    ///   - header: An optional header string.
    ///   - style: The style for the toggle. Defaults to themed style using the current theme.
    ///   - onChange: Closure to call when the value changes.
    init(
        isOn: Binding<Bool>,
        title: String,
        header: String? = nil,
        style: ItemToggleStyle = .themed(ThemeManager.shared.currentThemeStyle),
        onChange: ((Bool) -> Void)? = nil
    ) {
        self._isOn = isOn
        self.title = title
        self.header = header
        self.style = style
        self.onChange = onChange
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            if style.showHeader, let header = header {
                // Display header using a titled SectionHeader style
                SectionHeader(
                    title: LocaleManager.shared.localizedString(for: header),
                    style: .block(ThemeManager.shared.currentThemeStyle)
                )
            }
            
            SectionBody {
                toggleContent
                    .padding(.horizontal, style.spacing)
            }
        }
    }
    
    /// The toggle content with custom text and tint.
    private var toggleContent: some View {
        Toggle(isOn: Binding(
            get: { isOn },
            set: { newValue in
                isOn = newValue
                onChange?(newValue)
            }
        )) {
            Text(LocaleManager.shared.localizedString(for: title).capitalizedFirstLetter)
                .foregroundColor(style.titleColor)
        }
        .tint(style.tintColor)
    }
}
