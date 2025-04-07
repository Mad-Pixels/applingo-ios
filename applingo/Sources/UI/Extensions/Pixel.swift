import SwiftUI

struct PixelBackgroundEffect: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            Color.clear // Прозрачный базовый слой для заполнения GeometryReader
                .overlay(
                    ForEach(0..<25, id: \.self) { i in
                        Circle()
                            .fill(Color.red.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .position(
                                x: CGFloat.random(in: 0...geo.size.width),
                                y: animate ? geo.size.height + 50 : -50
                            )
                            .animation(
                                .linear(duration: 3)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(i) * 0.1),
                                value: animate
                            )
                    }
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.red.opacity(0.2))
        .onAppear {
            animate = true
        }
    }
}
