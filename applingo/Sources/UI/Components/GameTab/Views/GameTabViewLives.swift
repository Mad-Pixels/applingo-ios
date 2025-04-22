import SwiftUI

internal struct GameTabViewLives: View {
    @ObservedObject var survival: GameStateUtilsSurvival
    let style: GameTabStyle
    
    private let maxPerRow = 3
    
    var body: some View {
        let total = survival.initialLives
        let topRowCount = min(total, maxPerRow)
        let bottomRowCount = max(0, total - maxPerRow)
        
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                ForEach(0..<topRowCount, id: \.self) { index in
                    heartIcon(index)
                }
            }
            
            if bottomRowCount > 0 {
                HStack(spacing: 4) {
                    ForEach(0..<bottomRowCount, id: \.self) { i in
                        heartIcon(topRowCount + i)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: survival.lives)
    }
    
    @ViewBuilder
    private func heartIcon(_ index: Int) -> some View {
        Image(systemName: index < survival.lives ? "heart.fill" : "heart")
            .font(.system(size: style.iconSize))
            .foregroundColor(style.heartColor)
    }
}
