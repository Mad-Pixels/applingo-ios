import SwiftUI

struct TabViewStyle {
    struct UIKitStyle {
        let tabBarHeight: CGFloat
        let tabBarSpacing: CGFloat
        let fontSize: CGFloat
        let fontWeight: UIFont.Weight
    }
    
    struct SwiftUIStyle {
        let iconSize: CGFloat
        let selectedIconScale: CGFloat
        let cornerRadius: CGFloat
        let selectionAnimationDuration: Double
        let transitionAnimation: Animation
    }
    
    let uiKit: UIKitStyle
    let swiftUI: SwiftUIStyle
}

extension TabViewStyle {
    static var `default`: TabViewStyle {
        TabViewStyle(
            uiKit: UIKitStyle(
                tabBarHeight: 49,
                tabBarSpacing: 8,
                fontSize: 10,
                fontWeight: .medium
            ),
            swiftUI: SwiftUIStyle(
                iconSize: 24,
                selectedIconScale: 1.1,
                cornerRadius: 12,
                selectionAnimationDuration: 0.2,
                transitionAnimation: .easeInOut
            )
        )
    }
    
    static var compact: TabViewStyle {
        TabViewStyle(
            uiKit: UIKitStyle(
                tabBarHeight: 44,
                tabBarSpacing: 6,
                fontSize: 9,
                fontWeight: .regular
            ),
            swiftUI: SwiftUIStyle(
                iconSize: 20,
                selectedIconScale: 1.05,
                cornerRadius: 10,
                selectionAnimationDuration: 0.15,
                transitionAnimation: .easeInOut
            )
        )
    }
    
    static var large: TabViewStyle {
        TabViewStyle(
            uiKit: UIKitStyle(
                tabBarHeight: 56,
                tabBarSpacing: 10,
                fontSize: 11,
                fontWeight: .semibold
            ),
            swiftUI: SwiftUIStyle(
                iconSize: 28,
                selectedIconScale: 1.15,
                cornerRadius: 14,
                selectionAnimationDuration: 0.25,
                transitionAnimation: .easeInOut
            )
        )
    }
}

extension TabViewStyle {
    var uiFont: UIFont {
        .systemFont(ofSize: uiKit.fontSize, weight: uiKit.fontWeight)
    }
}
