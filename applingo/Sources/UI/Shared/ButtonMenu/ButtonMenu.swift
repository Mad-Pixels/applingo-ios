import SwiftUI

// MARK: - ButtonMenu View
/// A menu button that displays a title, an optional subtitle, and an optional icon.
/// The button shows a chevron indicator and applies custom styling.
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
    ///   - style: The style to apply. Defaults to themed style using LightTheme.
    ///   - action: The action to perform when tapped.
    init(
        title: String,
        subtitle: String? = nil,
        iconType: ButtonMenuIconType = .none,
        isSelected: Bool = false,
        action: @escaping () -> Void,
        style: ButtonMenuStyle = .themed(LightTheme())
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconType = iconType
        self.style = style
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: style.hStackSpacing) {
                iconView
                
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
    
    // Computed property for icon view based on iconType
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
