import SwiftUI

struct CompErrorView: View {
    let errorMessage: String
    let theme: ThemeStyle

    var body: some View {
        Text(errorMessage)
            .foregroundColor(theme.errorTextColor)
            .bold()
            .padding()
            .multilineTextAlignment(.center)
    }
}
