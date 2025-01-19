import SwiftUI

struct Home: View {
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    
    init(style: HomeStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(
            screen: .main,
            title: ""
        ) {
            Color.clear
            
            ZStack {
                MainBackground()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: style.spacing) {
                        ButtonIcon(
                            title: locale.quizTitle,
                            icon: "laser.burst",
                            style: .asGameSelect(ThemeManager.shared.currentThemeStyle.quizTheme)
                        )
                        
                        ButtonIcon(
                            title: locale.matchHuntTitle,
                            icon: "puzzlepiece",
                            style: .asGameSelect(ThemeManager.shared.currentThemeStyle.matchTheme)
                        )
                        
                        ButtonIcon(
                            title: locale.verifyItTitle,
                            icon: "number",
                            style: .asGameSelect(ThemeManager.shared.currentThemeStyle.swipeTheme)
                        )
                    }
                    .padding(style.padding)
                    .glassBackground()
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
        }
    }
}
