import SwiftUI

struct ButtonMenu: View {
    private let title: String
    private let subtitle: String?
    private let iconType: ButtonMenuIconType
    private let style: ButtonMenuStyle
    private let isSelected: Bool
    private let action: () -> Void

    /// Initializes the ButtonMenu.
    /// - Parameters:
    ///   - title: The primary title text.
    ///   - subtitle: Optional secondary text.
    ///   - iconType: The type of icon to display (system, resource, or none).
    ///   - isSelected: A flag indicating selection state.
    ///   - action: The action to perform when tapped.
    ///   - style: The style to apply. Defaults to themed style using LightTheme.
    init(
        title: String,
        subtitle: String? = nil,
        iconType: ButtonMenuIconType = .none,
        isSelected: Bool = false,
        action: @escaping () -> Void,
        style: ButtonMenuStyle = .themed(LightTheme())
    ) {
        self.isSelected = isSelected
        self.subtitle = subtitle
        self.iconType = iconType
        self.action = action
        self.title = title
        self.style = style
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: style.hStackSpacing) {
                iconView
                
                VStack(alignment: .leading) {
                    DynamicText(
                        model: DynamicTextModel(text: title),
                        style: .textBold(ThemeManager.shared.currentThemeStyle)
                    )
                    
                    if let subtitle = subtitle {
                        DynamicText(
                            model: DynamicTextModel(text: subtitle),
                            style: .textLight(ThemeManager.shared.currentThemeStyle)
                        )
                    }
                }
                Spacer()
                if style.transitionType != "" {
                    Image(systemName: style.transitionType)
                        .font(.system(size: 24))
                        .foregroundColor(style.foregroundColor)
                        .opacity(0.6)
                }
            }
            .padding(style.padding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                    .shadow(color: style.shadowColor.opacity(0.3), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Computed property for icon view based on iconType
    private var iconView: some View {
        Group {
            switch iconType {
            case .system(let name):
                Image(systemName: name)
                    .font(.system(size: style.iconSize))
                    .foregroundColor(style.iconColor)
                    .frame(width: style.iconFrameSize.width, height: style.iconFrameSize.height)
                    .background(Circle().fill(style.backgroundColor))
                
            case .resource(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(style.iconColor)
                    .frame(width: style.iconFrameSize.width, height: style.iconFrameSize.height)
                    .background(Circle().fill(style.backgroundColor))
                
            case .none:
                EmptyView()
            }
        }
    }
}
