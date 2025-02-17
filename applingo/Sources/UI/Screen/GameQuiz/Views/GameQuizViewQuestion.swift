import SwiftUI

/// A view that displays the quiz question card with a dynamic patterned background and border.
///
/// This view renders the quiz question text using the provided style and localization.
/// The question is centered, padded, and displayed on a card with adaptive dimensions.
/// The background of the card is enhanced with an animated dynamic pattern overlay,
/// and the border is rendered with a dynamic pattern.
///
/// - Environment:
///   - `themeManager`: Provides the current theme settings.
/// - Properties:
///   - `locale`: A `GameQuizLocale` object supplying localized strings.
///   - `style`: A `GameQuizStyle` object defining visual appearance and dynamic pattern details.
///   - `question`: The quiz question text to display.
struct GameQuizViewQuestion: View {
    // MARK: - Environment and Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let question: String
    
    // MARK: - Computed Properties
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * style.widthRatio
    }
    
    private var cardHeight: CGFloat {
        min(UIScreen.main.bounds.height * style.heightRatio, style.maxHeight)
    }
    
    // MARK: - Initializer
    /// Initializes a new instance of `GameQuizViewQuestion`.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object that defines visual appearance.
    ///   - question: The quiz question text to be displayed.
    init(locale: GameQuizLocale, style: GameQuizStyle, question: String) {
        self.locale = locale
        self.style = style
        self.question = question
    }
    
    private var questionText: some View {
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
    
    // MARK: - Body
    var body: some View {
        questionText
            .padding(style.cardPadding)
            .frame(width: cardWidth, height: cardHeight)
            .background(backgroundView)
            .cornerRadius(style.cardCornerRadius)
            .overlay(borderView)
            .shadow(
                // Если понадобится, можно использовать цвет тени из стиля:
                // color: style.cardShadowColor.opacity(style.shadowOpacity),
                radius: style.cardShadowRadius,
                x: style.shadowOffset.x,
                y: style.shadowOffset.y
            )
            .transition(.asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .scale(scale: 1.1).combined(with: .opacity)
            ))
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        ZStack {
            style.cardBackground
            PatternedBackground(style: style)
        }
    }
    
    // MARK: - Border View
    private var borderView: some View {
        PatternedBorder(style: style)
    }
}

// MARK: - Background Pattern Component
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

// MARK: - Border Pattern Component
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
