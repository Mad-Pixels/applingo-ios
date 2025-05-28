import SwiftUI

internal struct GameQuizViewQuestionText: View {
    let question: String
    let style: GameQuizStyle
    
    @State private var yOffset: CGFloat = -200
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var rotation: Double = -5
    
    var body: some View {
        GeometryReader { geometry in
            DynamicText(
                model: DynamicTextModel(text: question),
                style: .headerGame(
                    ThemeManager.shared.currentThemeStyle,
                    alignment: .center,
                    lineLimit: 5
                )
            )
            .frame(
                maxWidth: geometry.size.width * style.textWidthRatio,
                maxHeight: geometry.size.height * style.textHeightRatio,
                alignment: .center
            )
            .offset(y: yOffset)
            .opacity(opacity)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .animation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.7,
                    blendDuration: 0.3
                ),
                value: question
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
            .onAppear {
                withAnimation(
                    .spring(
                        response: 0.6,
                        dampingFraction: 0.7,
                        blendDuration: 0.3
                    )
                ) {
                    yOffset = 0
                    opacity = 1
                    scale = 1
                    rotation = 0
                }
            }
            .onChange(of: question) { newQuestion in
                withAnimation(.easeIn(duration: 0.3)) {
                    yOffset = 200
                    opacity = 0
                    scale = 0.6
                    rotation = 5
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    yOffset = -200
                    scale = 0.8
                    rotation = -5
                    
                    withAnimation(
                        .spring(
                            response: 0.6,
                            dampingFraction: 0.7,
                            blendDuration: 0.3
                        )
                    ) {
                        yOffset = 0
                        opacity = 1
                        scale = 1
                        rotation = 0
                    }
                }
            }
        }
    }
}
