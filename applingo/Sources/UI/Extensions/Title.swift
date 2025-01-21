import SwiftUI

extension View {
    func applyTitle(_ title: String?) -> some View {
        Group {
            if let title = title {
                self.navigationTitle(title)
            } else {
                self.navigationBarHidden(true)
            }
        }
    }
}
