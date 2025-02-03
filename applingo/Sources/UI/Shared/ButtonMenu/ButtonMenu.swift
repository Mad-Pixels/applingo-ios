import SwiftUI

// MARK: - ButtonMenu View
/// A menu button that displays a title, an optional subtitle, and an optional icon.
/// The button shows a chevron indicator and applies custom styling.
struct ButtonMenu: View {
    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let style: ButtonMenuStyle
    private let isSelected: Bool
    private let action: () -> Void

    /// Initializes the ButtonMenu.
    /// - Parameters:
    ///   - title: The primary title text.
    ///   - subtitle: Optional secondary text.
    ///   - icon: Optional SF Symbol icon name.
    ///   - isSelected: A flag indicating selection state.
    ///   - style: The style to apply. Defaults to themed style using LightTheme.
    ///   - action: The action to perform when tapped.
    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isSelected: Bool = false,
        style: ButtonMenuStyle = .themed(LightTheme()),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.style = style
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: style.hStackSpacing) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: style.iconSize))
                        .foregroundColor(style.iconColor)
                        .frame(width: style.iconFrameSize.width, height: style.iconFrameSize.height)
                        .background(
                            Circle()
                                .fill(style.backgroundColor)
                        )
                }
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(style.font)
                        .foregroundColor(style.foregroundColor)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(style.foregroundColor.opacity(0.7))
                            .lineLimit(2)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(style.foregroundColor)
                    .opacity(isSelected ? 1 : 0.5)
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
}
