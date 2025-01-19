import SwiftUI

struct Home: View {
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    @State private var showGameMode = false
    @State private var selectedGame: GameType = .quiz // Сразу инициализируем значением
    
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
                ButtonIcon(
                    title: locale.quizTitle,
                    icon: "laser.burst",
                    action: {
                        selectedGame = .quiz
                        showGameMode = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.quizTheme)
                )
                
                ButtonIcon(
                    title: locale.matchHuntTitle,
                    icon: "puzzlepiece",
                    action: {
                        selectedGame = .match
                        showGameMode = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.matchTheme)
                )
                
                ButtonIcon(
                    title: locale.verifyItTitle,
                    icon: "number",
                    action: {
                        selectedGame = .swipe
                        showGameMode = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.swipeTheme)
                )
            }
            .padding(style.padding)
            .glassBackground()
            .padding(.horizontal, 24)
        }
        .fullScreenCover(isPresented: $showGameMode) {
            NavigationView {
                GameMode(
                    isCoverPresented: $showGameMode,
                    gameType: selectedGame,
                    selectedMode: .constant(.practice),
                    showGameContent: .constant(false)
                )
            }
        }
    }
}
