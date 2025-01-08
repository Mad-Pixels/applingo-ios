import SwiftUI

struct SinglePreview: PreviewProvider {
    static var previews: some View {
        FloatingButtonSingle(
            icon: "heart.fill",
            action: {
                print("pressed")
            },
            style: .default
        )
    }
}
