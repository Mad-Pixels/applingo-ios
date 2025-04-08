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
        AnyView(PixelBackgroundEffect())
    }
}

extension GameSpecialBonusSilver {
    var backgroundEffectView: AnyView {
        AnyView(PixelBackgroundEffect())
    }
}

extension GameSpecialBonusGold {
    var backgroundEffectView: AnyView {
        AnyView(PixelBackgroundEffect())
    }
}

extension GameSpecialBonusUltra {
    var backgroundEffectView: AnyView {
        AnyView(PixelBackgroundEffect())
    }
}

extension GameSpecialBonusDeath {
    var backgroundEffectView: AnyView {
        AnyView(PixelBackgroundEffect())
    }
}
