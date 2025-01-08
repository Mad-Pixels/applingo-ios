import SwiftUI

struct MultiplePreview: PreviewProvider {
    static var previews: some View {
        FloatingButtonMultiple(
            items: [
                IconAction(icon: "heart.fill") { print("heart!") },
                IconAction(icon: "bookmark.fill") { print("bookmark!") },
                IconAction(icon: "paperplane.fill") { print("paper plane!") }
            ],
            style: .default
        )
    }
}
