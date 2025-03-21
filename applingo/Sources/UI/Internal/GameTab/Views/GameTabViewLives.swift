import SwiftUI

struct GameTabViewLives: View {
    let lives: Int
    let style: GameTabStyle
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Image(systemName: index < lives ? "heart.fill" : "heart")
                    .font(.system(size: style.iconSize))
                    .foregroundColor(style.accentColor)
            }
        }
    }
}
