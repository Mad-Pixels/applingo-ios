import SwiftUI

struct TabLearnView: View {
    var body: some View {
        NavigationView {
            ZStack {
                CompBackgroundWordsView().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Learn").capitalizedFirstLetter,
                        icon: "book.fill",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor1
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Quiz").capitalizedFirstLetter,
                        icon: "questionmark.circle.fill",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor2
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "MatchHunt").capitalizedFirstLetter,
                        icon: "arrow.2.squarepath",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor3
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "VerifyIt").capitalizedFirstLetter,
                        icon: "checkmark.circle.fill",
                        color: ThemeManager.shared.currentThemeStyle.secondatyAccentColor4
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
        }
    }
}
