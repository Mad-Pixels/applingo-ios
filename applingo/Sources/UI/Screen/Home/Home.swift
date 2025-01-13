import SwiftUI

struct Home: View {
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    
    // Флаг для полноэкранного отображения
    @State private var showGameMode = false
    
    init(style: HomeStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            MainBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: style.spacing) {
                // Кнопка 1 — Quiz
                ButtonIcon(
                    title: locale.quizTitle,
                    icon: "laser.burst",
                    action: {
                        showGameMode = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.quizTheme)
                )
                
                // Кнопка 2 — Match
                ButtonIcon(
                    title: locale.matchHuntTitle,
                    icon: "puzzlepiece",
                    action: {
                        showGameMode = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.matchTheme)
                )
                
                // Кнопка 3 — Verify
                ButtonIcon(
                    title: locale.verifyItTitle,
                    icon: "number",
                    action: {
                        showGameMode = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.swipeTheme)
                )
            }
            .padding(style.padding)
            .glassBackground()
            .padding(.horizontal, 24)
        }
        // fullScreenCover → GameModeWithNavView
        .fullScreenCover(isPresented: $showGameMode) {
            // Обёртка, в которую передаём флаг, чтобы закрыть всё
            GameModeWithNavView(isPresented: $showGameMode)
        }
    }
}


import SwiftUI

struct GameModeWithNavView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            GameMode(isCoverPresented: $isPresented)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
