import SwiftUI

// Special card icon.
extension OverlayIcon {
    static func GameAnswer(_ theme: AppTheme) -> OverlayIcon {
        OverlayIcon(style: .themed(theme))
    }
}

// Special card layout.
extension GameSpecialBonus {
    var backgroundColor: DynamicPatternModel { DynamicPatternModel(colors: [.white]) }
    var borderColor: DynamicPatternModel { DynamicPatternModel(colors: [.clear]) }
    var icon: Image? { nil }

    var backgroundEffectView: AnyView {
        AnyView(EmptyView())
    }
}

// MARK: Special boards

extension GameSpecialBonusBronze {
    var backgroundEffectView: AnyView {
        AnyView(
            GameSpecialBoardGrid(
                style: .colors(
                    ThemeManager.shared.currentThemeStyle,
                    colors: self.backgroundColor.colors
                )
            )
        )
    }
}

extension GameSpecialBonusSilver {
    var backgroundEffectView: AnyView {
        AnyView(
            GameSpecialBoardWaves(
                style: .colors(
                    ThemeManager.shared.currentThemeStyle,
                    colors: self.backgroundColor.colors
                )
            )
        )
    }
}

extension GameSpecialBonusGold {
    var backgroundEffectView: AnyView {
        AnyView(
            GameSpecialBoardPulsingCircles(
                style: .colors(
                    ThemeManager.shared.currentThemeStyle,
                    colors: self.backgroundColor.colors
                )
            )
        )
    }
}

extension GameSpecialBonusUltra {
    var backgroundEffectView: AnyView {
        AnyView(
            GameSpecialBoardStarLines(
                style: .colors(
                    ThemeManager.shared.currentThemeStyle,
                    colors: self.backgroundColor.colors
                )
            )
        )
    }
}

extension GameSpecialBonusDeath {
    var backgroundEffectView: AnyView {
        AnyView(
            GameSpecialBoardOrbitingParticles(
                style: .colors(
                    ThemeManager.shared.currentThemeStyle,
                    colors: self.backgroundColor.colors
                )
            )
        )
    }
}
