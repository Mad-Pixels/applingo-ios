import SwiftUI

struct PixelBackgroundEffect: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<25, id: \.self) { i in
                    Circle()
                        .fill(Color.red.opacity(0.5)) // 🔴 пиксели
                        .frame(width: 8, height: 8)
                        .offset(
                            x: CGFloat.random(in: -geo.size.width/2...geo.size.width/2),
                            y: animate ? geo.size.height + 50 : -50
                        )
                        .animation(
                            .linear(duration: 3)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.1),
                            value: animate
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 💥 расширяет вью на весь экран
        .background(Color.red.opacity(0.2)) // для дебага
        .onAppear {
            animate = true
        }
    }
}
