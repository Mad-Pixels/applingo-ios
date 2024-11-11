import SwiftUI

struct TabLearnView: View {
    @State private var showMatchHuntGame = false
    @State private var showVerifyItGame = false
    @State private var showLearnGame = false
    @State private var showQuizGame = false
    
    var body: some View {
        NavigationView {
            ZStack {
                CompBackgroundWordsView().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Learn").capitalizedFirstLetter,
                        icon: "book.fill",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor1,
                        action: { showLearnGame = true }
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Quiz").capitalizedFirstLetter,
                        icon: "questionmark.circle.fill",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor2,
                        action: { showQuizGame = true }
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "MatchHunt").capitalizedFirstLetter,
                        icon: "arrow.2.squarepath",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor3,
                        action: { showMatchHuntGame = true }
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "VerifyIt").capitalizedFirstLetter,
                        icon: "checkmark.circle.fill",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor4,
                        action: { showVerifyItGame = true }
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .glassBackground()
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .onAppear {
                FrameManager.shared.setActiveFrame(.learn)
            }
            .fullScreenCover(isPresented: $showLearnGame) {
                GameLearnView(isPresented: $showLearnGame)
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
        }
    }
}
