import SwiftUI

struct CompTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    let isEditing: Bool
    let border: Bool
    let theme: ThemeStyle
    let icon: String?

    init(
        placeholder: String,
        text: Binding<String>,
        isEditing: Bool,
        theme: ThemeStyle,
        border: Bool = false,
        minHeight: CGFloat = 156,
        icon: String? = nil
    ) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
        self.minHeight = minHeight
        self.theme = theme
        self.icon = icon
    }

    var body: some View {
        HStack(alignment: .top) {
            if let iconName = icon {
                Image(systemName: iconName)
                    .modifier(SecondaryIconStyle(theme: theme))
                    .padding(.top, 15)
            }

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .padding(6)
                    .disabled(!isEditing)
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isEditing ? theme.backgroundViewColor : theme.detailsColor)
                    )
                    .overlay(
                        Group {
                            if border {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isEditing ? theme.accentColor : Color(.systemGray4), lineWidth: isEditing ? 2 : 1)
                            }
                        }
                    )
                    .modifier(BaseTextStyle(theme: theme))
                    .frame(minHeight: minHeight)
                    .animation(.easeInOut(duration: 0.4), value: isEditing)

                if text.isEmpty {
                    Text(placeholder)
                        .modifier(BaseTextStyle(theme: theme))
                        .foregroundColor(theme.baseTextColor.opacity(0.5))
                        .padding(EdgeInsets(top: 14, leading: 12, bottom: 0, trailing: 6))
                        .allowsHitTesting(false)
                }
            }
            .modifier(BaseTextStyle(theme: theme))
        }
    }
}
