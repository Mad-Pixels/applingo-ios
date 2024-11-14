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
                .background(theme.backgroundBlockColor)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius)
                        .stroke(theme.accentColor.opacity(0.2), lineWidth: Layout.borderWidth)
                )
                .shadow(
                    color: theme.accentColor.opacity(0.1),
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
            .foregroundColor(theme.secondaryTextColor)
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
            .fill(theme.accentColor)
            .frame(height: Layout.dividerHeight)
            .padding(.horizontal, Layout.dividerHorizontalPadding)
    }
    
    func hintButton(isActive: Bool) -> some View {
        Image(systemName: "lightbulb.fill")
            .font(Typography.titleFont)
            .foregroundColor(isActive ? .yellow : theme.accentColor)
            .padding(.top, Layout.topPadding)
    }
    
    func hintContainer<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 4) {
            content()
        }
        .padding(.top, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    func hintPenalty() -> some View {
        Text("-5 points")
            .font(Typography.secondaryFont)
            .foregroundColor(theme.secondaryTextColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(Color.yellow.opacity(0.1))
            )
    }
}

extension GameCardStyle {
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
