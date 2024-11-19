import SwiftUI

struct TabLearnView: View {
    @ObservedObject private var languageManager = LanguageManager.shared

    @State private var showMatchHuntGame = false
    @State private var showVerifyItGame = false
    @State private var showLearnGame = false
    @State private var showQuizGame = false
    @State private var showLettersGame = false
    
    var body: some View {
        NavigationView {
            ZStack {
                CompBackgroundWordsView().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Quiz").capitalizedFirstLetter,
                        icon: "laser.burst",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor1,
                        action: { showQuizGame = true }
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "MatchHunt").capitalizedFirstLetter,
                        icon: "puzzlepiece",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor2,
                        action: { showMatchHuntGame = true }
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "VerifyIt").capitalizedFirstLetter,
                        icon: "number",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor3,
                        action: { showVerifyItGame = true }
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Letters").capitalizedFirstLetter,
                        icon: "aqi.medium",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor4,
                        action: { showLettersGame = true }
                    )
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 16)
                .glassBackground()
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showQuizGame) {
                GameQuizView(isPresented: $showQuizGame)
            }
            .fullScreenCover(isPresented: $showMatchHuntGame) {
                GameMatchHuntView(isPresented: $showMatchHuntGame)
            }
            .fullScreenCover(isPresented: $showVerifyItGame) {
                GameVerifyItView(isPresented: $showVerifyItGame)
            }
            .fullScreenCover(isPresented: $showLettersGame) {
                GameLettersView(isPresented: $showLettersGame)
            }
        }
    }
}
