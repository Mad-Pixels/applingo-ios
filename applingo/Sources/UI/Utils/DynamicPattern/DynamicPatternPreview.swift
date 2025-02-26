import SwiftUI

// MARK: - DynamicPattern Preview
struct DynamicPatternPreview: PreviewProvider {
    static var previews: some View {
        // Example canvas size
        let canvasSize = CGSize(width: 300, height: 300)
        // Sample model with a set of colors
        let model = DynamicPatternModel(colors: [.blue, .red, .green])
        
        // Display the dynamic pattern with default configuration
        DynamicPattern(model: model, size: canvasSize)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
