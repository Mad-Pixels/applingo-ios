import SwiftUI

struct TabViewBaseStyle {
    struct UIKitStyle {
        // basic
        let fontWeight: UIFont.Weight
        let tabBarSpacing: CGFloat
        let tabBarHeight: CGFloat
        let fontSize: CGFloat
        
        // colors default state
        let backgroundColor: Color
        let normalTitleColor: Color
        let normalIconColor: Color
        
        // colors selected state
        let selectedTitleColor: Color
        let selectedIconColor: Color
    }
    
    let uiKit: UIKitStyle
}

extension TabViewBaseStyle {
    static var `default`: TabViewBaseStyle {
        TabViewBaseStyle(
            uiKit: UIKitStyle(
                fontWeight: .medium,
                tabBarSpacing: 8,
                tabBarHeight: 49,
                fontSize: 10,
                
                backgroundColor: .white,
                normalTitleColor: .gray,
                normalIconColor: .gray,
                
                selectedTitleColor: .blue,
                selectedIconColor: .blue
            )
        )
    }
}

extension TabViewBaseStyle {
    var uiFont: UIFont {
        .systemFont(ofSize: uiKit.fontSize, weight: uiKit.fontWeight)
    }
}
