import SwiftUI

struct TabLearnView: View {
    var body: some View {
        NavigationView {
            ZStack {
                CompBackgroundWordsView().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Learn").capitalizedFirstLetter,
                        icon: "book.fill"
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "Quiz").capitalizedFirstLetter,
                        icon: "questionmark.circle.fill"
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "MatchHunt").capitalizedFirstLetter,
                        icon: "arrow.2.squarepath"
                    )
                    CompButtonGameMenuView(
                        LanguageManager.shared.localizedString(for: "VerifyIt").capitalizedFirstLetter,
                        icon: "checkmark.circle.fill"
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
