import SwiftUI

struct ItemToggle: View {
    @Binding var isOn: Bool
    let title: String
    let header: String?
    let style: ItemToggleStyle
    let onChange: ((Bool) -> Void)?
    
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
        Group {
            if style.showHeader && header != nil {
                Section(
                    header: Text(LocaleManager.shared.localizedString(for: header!))
                        .foregroundColor(style.headerColor)
                ) {
                    toggleContent
                }
            } else {
                toggleContent
            }
        }
        .background(style.backgroundColor)
    }
    
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
