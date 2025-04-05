import SwiftUI

internal struct GameSwipePatternImage: View {
    private let image: Image

    var body: some View {
        image
            .resizable()
            .scaledToFill()
    }

    init(
        model: DynamicPatternModel,
        size: CGSize,
        config: DynamicPatternConfig = .default
    ) {
        let renderer = ImageRenderer(content:
            DynamicPattern(model: model, size: size, config: config)
        )
        renderer.scale = UIScreen.main.scale
        if let uiImage = renderer.uiImage {
            self.image = Image(uiImage: uiImage)
        } else {
            self.image = Image("")
        }
    }
}
