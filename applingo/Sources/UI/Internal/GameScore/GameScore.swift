import SwiftUI

/// A view that displays the last scored points along with its associated icon.
struct GameScore: View {
    @ObservedObject var stats: GameStats
    
    init(stats: GameStats) {
        self.stats = stats
    }

    var body: some View {
        HStack {
            // Иконка, соответствующая типу начисления очков
            Image(systemName: stats.score.type.iconName)
                .resizable()
                .frame(width: 64, height: 64)
            
            // Текст, показывающий знак и абсолютное значение очков
            Text("\(stats.score.sign)\(abs(stats.score.value))")
                //.font(style.font)
                //.foregroundColor(style.textColor)
        }
    }
}
