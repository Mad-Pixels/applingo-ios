import SwiftUI

struct GoldCardModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .if(isActive) { view in
                view.shadow(
                    color: .yellow.opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 0
                )
            }
    }
}
