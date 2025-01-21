import SwiftUI

struct MainBackground: View {
    @StateObject private var manager = MainBackgroundManager.shared
    @StateObject private var motionManager = MotionManager.shared
    
    private let parallaxStrength: CGFloat = 60
    
    var body: some View {
        ZStack {
            let theme = ThemeManager.shared.currentThemeStyle
            let words = manager.backgroundWords
            
            if !words.isEmpty {
                ForEach(words, id: \.id) { word in
                    Text(word.word)
                        .font(Font(word.font))
                        .position(
                            x: word.position.x + CGFloat(motionManager.roll) * parallaxStrength * (word.opacity * 2),
                            y: word.position.y + CGFloat(motionManager.pitch) * parallaxStrength * (word.opacity * 2)
                        )
                        .foregroundColor(theme.textSecondary.opacity(word.opacity))
                }
            }
        }
        .onAppear {
            manager.generateIfNeeded(for: UIScreen.main.bounds.size)
        }
    }
}
