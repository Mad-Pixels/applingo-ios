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
        UIScreen.main.bounds.width * Constants.widthRatio
    }
    
    private var cardHeight: CGFloat {
        min(UIScreen.main.bounds.height * Constants.heightRatio, Constants.maxHeight)
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
    
    // MARK: - Body
    var body: some View {
        Text(question)
            .font(style.questionFont)
            .foregroundColor(style.questionTextColor)
            .multilineTextAlignment(.center)
            .padding(style.cardPadding)
            .frame(width: cardWidth, height: cardHeight)
            .background(backgroundView)
            .cornerRadius(style.cardCornerRadius)
            .overlay(borderView)
            .shadow(
                color: style.questionTextColor.opacity(Constants.shadowOpacity),
                radius: style.cardShadowRadius,
                x: Constants.shadowOffset.x,
                y: Constants.shadowOffset.y
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
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            DynamicPattern(
                model: style.pattern,
                size: CGSize(
                    width: geometry.size.width * Constants.patternScale,
                    height: geometry.size.height * Constants.patternScale
                )
            )
            .opacity(Constants.patternOpacity)
            .scaleEffect(isAnimating ? 1 : Constants.patternMinScale)
            .animation(
                .easeInOut(duration: Constants.patternAnimationDuration)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .mask(
                RoundedRectangle(cornerRadius: style.cardCornerRadius)
            )
            .onAppear {
                isAnimating = true
            }
        }
    }
}

// MARK: - Border Pattern Component
private struct PatternedBorder: View {
    let style: GameQuizStyle
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: style.cardCornerRadius)
                .strokeBorder(Color.clear, lineWidth: Constants.borderWidth)
                .background(
                    DynamicPattern(
                        model: style.pattern,
                        size: CGSize(
                            width: geometry.size.width * Constants.patternScale,
                            height: geometry.size.height * Constants.patternScale
                        )
                    )
                    .scaleEffect(isAnimating ? 1 : Constants.patternMinScale)
                    .animation(
                        .easeInOut(duration: Constants.patternAnimationDuration)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                )
                .mask(
                    RoundedRectangle(cornerRadius: style.cardCornerRadius)
                        .strokeBorder(style: StrokeStyle(lineWidth: Constants.borderWidth))
                )
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

// MARK: - Constants
private enum Constants {
    // Card Dimensions
    static let widthRatio: CGFloat = 0.9
    static let heightRatio: CGFloat = 0.25
    static let maxHeight: CGFloat = 200
    
    // Pattern Properties
    static let patternScale: CGFloat = 2.0
    static let patternOpacity: CGFloat = 0.2
    static let patternMinScale: CGFloat = 0.95
    static let patternAnimationDuration: Double = 4.0
    
    // Border Properties
    static let borderWidth: CGFloat = 8
    
    // Shadow Properties
    static let shadowOpacity: CGFloat = 0.15
    static let shadowOffset = CGPoint(x: 0, y: 2)
}

