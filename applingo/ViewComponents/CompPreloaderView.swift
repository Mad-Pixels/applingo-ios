import SwiftUI

struct CompPreloaderView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView(LanguageManager.shared.localizedString(for: "Loading"))
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
    }
}
