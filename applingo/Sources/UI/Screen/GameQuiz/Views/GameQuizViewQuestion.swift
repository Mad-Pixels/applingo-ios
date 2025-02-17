import SwiftUI

// MARK: - GameQuizViewQuestion

/// A view that displays a quiz question card with a dynamic patterned background and border.
///
/// This view renders the quiz question text using a dynamic text component styled via a theme.
/// The question is centered and padded on a card with adaptive dimensions. Its background is enhanced
/// with an animated dynamic pattern overlay, and the border is rendered with an animated dynamic pattern.
///
/// - Environment:
///   - `themeManager`: Provides the current theme settings.
/// - Properties:
///   - `locale`: `GameQuizLocale` object supplying localized strings.
///   - `style`: `GameQuizStyle` object defining visual appearance and dynamic pattern details.
///   - `question`: The quiz question text to display.
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
            .background(backgroundView)
            .cornerRadius(style.cardCornerRadius)
            .overlay(borderView)
            .shadow(
                radius: style.cardShadowRadius,
                x: style.shadowOffset.x,
                y: style.shadowOffset.y
            )
            .transition(.asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .scale(scale: 1.1).combined(with: .opacity)
            ))
    }
    
    // MARK: - Private Methods
    /// The background view consisting of a solid color and an animated dynamic pattern overlay.
    private var backgroundView: some View {
        ZStack {
            style.cardBackground
            PatternedBackground(style: style)
        }
    }
    
    /// The border view that renders an animated dynamic pattern border.
    private var borderView: some View {
        PatternedBorder(style: style)
    }
}

// MARK: - Private Views
/// A view that displays the quiz question using the DynamicText component.
/// It is responsible for sizing and centering the question text.
private struct GameQuizQuestionText: View {
    let question: String
    let style: GameQuizStyle
    
    var body: some View {
        GeometryReader { geometry in
            DynamicText(
                model: DynamicTextModel(text: question),
                style: .gameMain(ThemeManager.shared.currentThemeStyle)
            )
            .frame(
                maxWidth: geometry.size.width * style.textWidthRatio,
                maxHeight: geometry.size.height * style.textHeightRatio,
                alignment: .center
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
}

/// A view that displays an animated dynamic pattern as the background of the quiz question card.
private struct PatternedBackground: View {
    let style: GameQuizStyle
    
    var body: some View {
        GeometryReader { geometry in
            DynamicPatternViewBackgroundAnimated(
                model: style.pattern,
                size: CGSize(
                    width: geometry.size.width * 1.1,
                    height: geometry.size.height * 1.1
                ),
                cornerRadius: style.cardCornerRadius,
                minScale: style.patternMinScale,
                opacity: style.patternOpacity,
                animationDuration: style.patternAnimationDuration
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
}

/// A view that displays an animated dynamic pattern as the border of the quiz question card.
private struct PatternedBorder: View {
    let style: GameQuizStyle
    
    var body: some View {
        GeometryReader { geometry in
            DynamicPatternViewBorderAnimated(
                model: style.pattern,
                size: CGSize(
                    width: geometry.size.width * 1.1,
                    height: geometry.size.height * 1.1
                ),
                cornerRadius: style.cardCornerRadius,
                minScale: style.patternMinScale,
                animationDuration: style.patternAnimationDuration,
                borderWidth: style.borderWidth
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
}
