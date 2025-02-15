import SwiftUI

/// A view that displays the last scored points along with its associated icon.
struct GameScore: View {
    /// The model containing the score value and its type (used for icon).
    let score: GameScoringScoreAnswerModel
    /// Styling parameters for the view.
    //let style: GameTabStyle
    /// Locale information for the view (например, для локализации текста).
    //let locale: GameTabLocale

    var body: some View {
        HStack() {
            // Иконка, соответствующая типу начисления очков
            Image(systemName: score.type.iconName)
                .resizable()
                .frame(width: 64, height: 64)
            
            // Текст, показывающий знак и абсолютное значение очков
            Text("\(score.sign)\(abs(score.value))")
                //.font(style.font)
                //.foregroundColor(style.textColor)
        }
    }
}
