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
        VStack(spacing: style.spacing) {
            if style.showHeader, let header = header {
                SectionHeader(
                    title: LocaleManager.shared.localizedString(for: header),
                    style: .titled(ThemeManager.shared.currentThemeStyle)
                )
            }
            
            SectionBody {
                toggleContent
                    .padding(.horizontal, style.spacing)
            }
        }
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
