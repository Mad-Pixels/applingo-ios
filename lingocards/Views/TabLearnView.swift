import SwiftUI

struct TabLearnView: View {
    var body: some View {
        NavigationView {
            ZStack {
                CompBackgroundWordsView().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    MenuButton(
                        "Learn",
                        icon: "book.fill"
                    )
                    
                    MenuButton(
                        "Quiz",
                        icon: "questionmark.circle.fill"
                    )
                    
                    MenuButton(
                        "Shuffle",
                        icon: "arrow.2.squarepath"
                    )
                    
                    MenuButton(
                        "TrueOrFalse",
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
