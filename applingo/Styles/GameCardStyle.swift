import SwiftUI

struct GameCardStyle {
    let theme: ThemeStyle
    
    struct Layout {
        static let width = UIScreen.main.bounds.width - 40
        static let height: CGFloat = 520
        static let cornerRadius: CGFloat = 24
        
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 40
        static let topPadding: CGFloat = 16
        
        static let dividerHeight: CGFloat = 2
        static let dividerHorizontalPadding: CGFloat = 20
        
        static let borderWidth: CGFloat = 1.5
        static let shadowRadius: CGFloat = 15
        static let shadowY: CGFloat = 8
        
        struct Animation {
            static let defaultDuration: Double = 0.3
            static let springDamping: Double = 0.7
            static let springResponse: Double = 0.35
        }
    }
    
    struct Typography {
        static let titleFont = Font.system(.title3, design: .rounded).weight(.semibold)
        static let mainTextFont = Font.system(size: 32, design: .rounded).weight(.bold)
        static let captionFont = Font.caption
        static let hintFont = Font.system(size: 14)
        static let secondaryFont = Font.caption2
    }
    
    struct BaseCardModifier: ViewModifier {
        let theme: ThemeStyle
        
        func body(content: Content) -> some View {
            content
                .frame(width: Layout.width, height: Layout.height)
                .background(theme.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius)
                        .stroke(theme.accentPrimary.opacity(0.2), lineWidth: Layout.borderWidth)
                )
                .shadow(
                    color: theme.accentPrimary.opacity(0.1),
                    radius: Layout.shadowRadius,
                    x: 0,
                    y: Layout.shadowY
                )
        }
    }
    
    struct SpecialEffectsModifier: ViewModifier {
        let isSpecial: Bool
        let specialService: GameSpecialService
        
        func body(content: Content) -> some View {
            if isSpecial {
                content.applySpecialEffects(specialService.getModifiers())
            } else {
                content
            }
        }
    }
    
    func makeBaseModifier() -> BaseCardModifier {
        BaseCardModifier(theme: theme)
    }
    
    func makeSpecialEffectsModifier(
        isSpecial: Bool,
        specialService: GameSpecialService
    ) -> SpecialEffectsModifier {
        SpecialEffectsModifier(
            isSpecial: isSpecial,
            specialService: specialService
        )
    }
    
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(Typography.captionFont)
            .foregroundColor(theme.accentDark)
            .padding(.top, Layout.topPadding)
    }
    
    func mainText(_ text: String) -> some View {
        Text(text)
            .font(Typography.mainTextFont)
            .multilineTextAlignment(.center)
            .padding(.vertical, Layout.verticalPadding)
    }
    
    func divider() -> some View {
        Rectangle()
            .fill(theme.accentPrimary)
            .frame(height: Layout.dividerHeight)
            .padding(.horizontal, Layout.dividerHorizontalPadding)
    }
    
    func hintButton(isActive: Bool) -> some View {
       Image(systemName: isActive ? "wand.and.stars" : "wand.and.stars.inverse")
           .font(Typography.titleFont)
           .foregroundColor(isActive ? .yellow : theme.accentPrimary)
           .padding(.top, Layout.topPadding)
           .shadow(color: isActive ? .yellow.opacity(0.5) : .clear, radius: 5)
    }
    
    func hintContainer<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 4) {
            content()
        }
        .padding(.top, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    func hintPenalty() -> some View {
        Text(LanguageManager.shared.localizedString(for: "HintPenalty").uppercased())
            .font(Typography.secondaryFont)
            .foregroundColor(theme.textSecondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(Color.yellow.opacity(0.1))
            )
    }
    
    struct QuizOptionStyle {
        let theme: ThemeStyle
        static let height: CGFloat = 56
        static let cornerRadius: CGFloat = 12
        
        func optionStyle(
            isSelected: Bool,
            isCorrect: Bool,
            isAnswered: Bool
        ) -> some ViewModifier {
            QuizOptionStyleModifier(
                theme: theme,
                isSelected: isSelected,
                isCorrect: isCorrect,
                isAnswered: isAnswered
            )
        }
    }

    var quiz: QuizOptionStyle {
        QuizOptionStyle(theme: theme)
    }
    
    struct Letters {
        let theme: ThemeStyle
        
        static let buttonSize: CGFloat = 50
        static let gridSpacing: CGFloat = 12
        static let gridPadding: CGFloat = 8
        static let wordSectionHeight: CGFloat = 80
        static let answerSectionHeight: CGFloat = 100
        
        func buttonStyle(for style: GameLetterStyle) -> some ViewModifier {
            LetterButtonStyleModifier(style: style, theme: theme)
        }
    }
    
    var letters: Letters {
        Letters(theme: theme)
    }
    
    struct SwipeCard {
        static let rotationMultiplier: Double = 20
        static let maxRotation: Double = 45
        static let dragWidthDivisor: CGFloat = 300
        static let swipeThreshold: CGFloat = 100
        
        static let overlayFont = Font.system(size: 48, weight: .heavy)
        static let overlayPadding: CGFloat = 20
        static let overlayCornerRadius: CGFloat = 15
        static let overlayRotation: Double = 30
        static let overlayOpacity: Double = 0.15
    }
    
    func swipeOverlay(
        text: String,
        color: Color,
        opacity: Double,
        rotation: Double
    ) -> some View {
        Text(text.uppercased())
            .font(SwipeCard.overlayFont)
            .foregroundColor(color)
            .padding(SwipeCard.overlayPadding)
            .background(
                RoundedRectangle(cornerRadius: SwipeCard.overlayCornerRadius)
                    .fill(color.opacity(SwipeCard.overlayOpacity))
            )
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
    }
}

private struct QuizOptionStyleModifier: ViewModifier {
    let theme: ThemeStyle
    let isSelected: Bool
    let isCorrect: Bool
    let isAnswered: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: GameCardStyle.QuizOption.height)
            .background(backgroundColor)
            .cornerRadius(GameCardStyle.QuizOption.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: GameCardStyle.QuizOption.cornerRadius)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: shadowColor,
                radius: isSelected ? 5 : 2,
                x: 0,
                y: isSelected ? 2 : 1
            )
    }
    
    private var foregroundColor: Color {
        if !isAnswered {
            return isSelected ? .white : theme.textPrimary
        } else {
            return isCorrect ? .white : theme.textPrimary
        }
    }
    
    private var backgroundColor: Color {
        if !isAnswered {
            return isSelected ? theme.accentPrimary : theme.backgroundSecondary
        } else {
            if isCorrect {
                return .green
            } else if isSelected {
                return .red
            } else {
                return theme.backgroundSecondary
            }
        }
    }
    
    private var borderColor: Color {
        if !isAnswered {
            return isSelected ? .clear : theme.textSecondary.opacity(0.3)
        } else {
            if isCorrect {
                return .green
            } else if isSelected {
                return .red
            } else {
                return theme.textSecondary.opacity(0.3)
            }
        }
    }
    
    private var shadowColor: Color {
        if !isAnswered {
            return isSelected ?
                theme.accentPrimary.opacity(0.3) :
                theme.textSecondary.opacity(0.1)
        } else {
            if isCorrect {
                return Color.green.opacity(0.3)
            } else if isSelected {
                return Color.red.opacity(0.3)
            } else {
                return theme.textSecondary.opacity(0.1)
            }
        }
    }
}

private struct LetterButtonStyleModifier: ViewModifier {
    let style: GameLetterStyle
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: GameCardStyle.Layout.cornerRadius))
            .shadow(color: shadowColor, radius: 2, x: 0, y: 1)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .option:
            return Color(.systemGray6)
        case .answer:
            return Color(.systemBackground)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .option:
            return theme.textPrimary
        case .answer:
            return theme.accentPrimary
        }
    }
    
    private var shadowColor: Color {
        theme.textSecondary.opacity(0.2)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(
                .easeInOut(duration: GameCardStyle.Layout.Animation.defaultDuration),
                value: configuration.isPressed
            )
    }
}
