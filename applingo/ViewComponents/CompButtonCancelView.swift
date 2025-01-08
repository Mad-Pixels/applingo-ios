import SwiftUI

struct CompButtonCancelView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .modifier(BaseTextStyle())
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 15)
                .bold()
        }
        .buttonStyle(
            BaseButtonStyle(
                backgroundColor: ThemeManager.shared.currentThemeStyle.accentPrimary,
                textColor: ThemeManager.shared.currentThemeStyle.textPrimary
            )
        )
    }
}
