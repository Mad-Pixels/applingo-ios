import SwiftUI

struct TabLearnView: View {
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
                
                CompBackgroundWordsView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
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
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "Learn").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                FrameManager.shared.setActiveFrame(.learn)
            }
        }
    }
}
