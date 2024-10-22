import SwiftUI

struct CompButtonAction: View {
    let title: String
    let action: () -> Void
    let theme: ThemeStyle

    var body: some View {
        Button(action: action) {
            Text(title)
                .modifier(BaseTextStyle(theme: theme))
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 15)
                .bold()
        }
        .buttonStyle(
            BaseButtonStyle(
                theme: theme,
                backgroundColor: theme.accentColor,
                textColor: theme.baseTextColor
            )
        )
    }
}
