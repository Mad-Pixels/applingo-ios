import SwiftUI

struct MainBackground: View {
    @ObservedObject private var manager = BackgroundWordsManager.shared
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
            
        GeometryReader { geometry in
            ZStack {
                ForEach(manager.backgroundWords, id: \.id) { word in
                    Text(word.word)
                        .font(Font(word.font))
                        .position(word.position)
                        .foregroundColor(theme.textSecondary.opacity(word.opacity))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                manager.generateIfNeeded(for: geometry.size)
            }
        }
    }
}
