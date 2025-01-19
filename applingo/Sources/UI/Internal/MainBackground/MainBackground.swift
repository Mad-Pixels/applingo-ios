import SwiftUI

struct MainBackground: View {
    @StateObject private var manager = MainBackgroundManager.shared
    
    var body: some View {
        ZStack {
            let theme = ThemeManager.shared.currentThemeStyle
            let words = manager.backgroundWords
            
            if !words.isEmpty {
                ForEach(words, id: \.id) { word in
                    Text(word.word)
                        .font(Font(word.font))
                        .position(word.position)
                        .foregroundColor(theme.textSecondary.opacity(word.opacity))
                }
            }
        }
        .onAppear {
            manager.generateIfNeeded(for: UIScreen.main.bounds.size)
        }
    }
}
