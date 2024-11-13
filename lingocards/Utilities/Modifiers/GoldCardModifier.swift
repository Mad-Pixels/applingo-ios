import SwiftUI

struct GoldCardModifier: ViewModifier {
    let isActive: Bool
    @State private var glowOpacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isActive {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 4)
                                    .blur(radius: 4)
                                    .opacity(glowOpacity)
                            )
                    }
                }
            )
            .onAppear {
                if isActive {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        glowOpacity = 0.8
                    }
                }
            }
    }
}
