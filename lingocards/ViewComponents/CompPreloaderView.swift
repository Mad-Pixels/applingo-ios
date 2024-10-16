import SwiftUI

struct CompPreloaderView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
    }
}

struct CompPreloaderView_Previews: PreviewProvider {
    static var previews: some View {
        CompPreloaderView()
    }
}
