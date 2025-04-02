import SwiftUI

struct WaveEffect: ViewModifier {
    let isActive: Bool
    let colors: [Color]
    let radius: CGFloat
    
    private let amplitudeMultiplier: CGFloat = 1.2
    private let baseFrequency: Double = 1.5
    private let waveSpeed: Double = 1.2
    private let waveCount = 3
    
    @State private var opacity: Double = 0.0
    @State private var phase: Double = 0.0
    @State private var timer: Timer?
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<waveCount, id: \.self) { waveIndex in
                ForEach(0..<colors.count, id: \.self) { colorIndex in
                    let color = colors[colorIndex]
                    let waveOffset = Double(waveIndex) * (2 * .pi / Double(waveCount))
                    let frequency = baseFrequency + Double(colorIndex) * 0.3
                    
                    content
                        .foregroundColor(color)
                        .blur(radius: radius * (1.0 + sin(phase * frequency + waveOffset) * amplitudeMultiplier * 0.4))
                        .opacity(opacity * (0.7 - Double(waveIndex) * 0.15))
                }
            }
            content
        }
        .onChange(of: isActive) { active in
            if active {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
        .onAppear {
            if isActive {
                startAnimation()
            }
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeIn(duration: 0.3)) {
            opacity = 1.0
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            withAnimation(.linear(duration: 0.016)) {
                phase += 0.07 * waveSpeed
                if phase > 2 * .pi {
                    phase -= 2 * .pi
                }
            }
        }
    }
    
    private func stopAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 0.0
        }
        timer?.invalidate()
        timer = nil
    }
}
