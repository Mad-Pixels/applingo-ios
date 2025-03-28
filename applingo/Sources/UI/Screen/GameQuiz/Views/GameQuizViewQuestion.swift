import SwiftUI

/// A view that displays a quiz question card with a dynamic patterned background and border.
///
/// This view renders the quiz question text using a dynamic text component styled via a theme.
/// The question is centered and padded on a card with adaptive dimensions. Its background is enhanced
/// with an animated dynamic pattern overlay, and the border is rendered with an animated dynamic pattern.
struct GameQuizViewQuestion: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let question: String
    
    // MARK: - Computed Properties
    /// The card's width, calculated based on the screen width and the style's width ratio.
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * style.widthRatio
    }
    
    /// The card's height, limited by the screen height and the style's maximum height.
    private var cardHeight: CGFloat {
        min(UIScreen.main.bounds.height * style.heightRatio, style.maxHeight)
    }
    
    // MARK: - Initializer
    /// Initializes a new instance of `GameQuizViewQuestion`.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object that defines the visual appearance.
    ///   - question: The quiz question text to be displayed.
    init(locale: GameQuizLocale, style: GameQuizStyle, question: String) {
        self.locale = locale
        self.style = style
        self.question = question
    }
    
    // MARK: - Body
    var body: some View {
        GameQuizQuestionText(question: question, style: style)
            .padding(style.cardPadding)
            .frame(width: cardWidth, height: cardHeight)
            // Base background color.
            .background(style.cardBackground)
            // Apply the animated dynamic background using the modifier.
            .animatedBackground(
                model: style.pattern,
                size: CGSize(width: cardWidth * 1.1, height: cardHeight * 1.1),
                cornerRadius: style.cardCornerRadius,
                minScale: style.patternMinScale,
                opacity: style.patternOpacity,
                animationDuration: style.patternAnimationDuration
            )
            .cornerRadius(style.cardCornerRadius)
            // Apply the animated border using the previously defined modifier.
            .animatedBorder(
                model: style.pattern,
                size: CGSize(width: cardWidth * 1.1, height: cardHeight * 1.1),
                cornerRadius: style.cardCornerRadius,
                minScale: style.patternMinScale,
                animationDuration: style.patternAnimationDuration,
                borderWidth: style.borderWidth
            )
            .shadow(
                radius: style.cardShadowRadius,
                x: style.shadowOffset.x,
                y: style.shadowOffset.y
            )
    }
}

// MARK: - Private Views
/// A view that displays the quiz question using the DynamicText component.
private struct GameQuizQuestionText: View {
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
                style: .headerGame(ThemeManager.shared.currentThemeStyle)
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
