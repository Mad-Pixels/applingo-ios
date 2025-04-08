import SwiftUI

struct ItemToggle: View {
    @Binding var isOn: Bool
    
    let title: String
    let style: ItemToggleStyle
    let onChange: ((Bool) -> Void)?
    
    /// Initializes the ItemToggle.
    /// - Parameters:
    ///   - isOn: Binding to the toggle state.
    ///   - title: The title of the toggle.
    ///   - style: The style for the toggle. Defaults to themed style using the current theme.
    ///   - onChange: Closure to call when the value changes.
    init(
        isOn: Binding<Bool>,
        title: String,
        onChange: ((Bool) -> Void)? = nil,
        style: ItemToggleStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._isOn = isOn
        self.title = title
        self.style = style
        self.onChange = onChange
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
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
            DynamicText(
                model: DynamicTextModel(text: title.capitalizedFirstLetter),
                style: .textMain(ThemeManager.shared.currentThemeStyle)
            )
        }
        .tint(style.tintColor)
    }
}
