import SwiftUI

struct CompGameLetterGridView: View {
    let letters: [Character]
    let onTap: (Character) -> Void
    let style: GameLetterStyle
    let cardStyle: GameCardStyle
    
    private let columns = [
        GridItem(.adaptive(minimum: GameCardStyle.Letters.buttonSize), spacing: GameCardStyle.Letters.gridSpacing)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: GameCardStyle.Letters.gridSpacing) {
            ForEach(letters, id: \.self) { letter in
                CompGameLetterButton(letter: letter, style: style, cardStyle: cardStyle, onTap: onTap)
            }
        }
        .padding(GameCardStyle.Letters.gridPadding)
    }
}

struct CompGameLetterButton: View {
    let letter: Character
    let style: GameLetterStyle
    let cardStyle: GameCardStyle
    let onTap: (Character) -> Void
    
    var body: some View {
        Button(action: { onTap(letter) }) {
            Text(String(letter))
                .font(GameCardStyle.Typography.titleFont)
                .frame(
                    width: GameCardStyle.Letters.buttonSize,
                    height: GameCardStyle.Letters.buttonSize
                )
                .modifier(cardStyle.letters.buttonStyle(for: style))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct CompGameLetterContentSections {
    struct WordSection: View {
        let word: WordItemModel
        let style: GameCardStyle
        
        var body: some View {
            VStack(spacing: GameCardStyle.Layout.topPadding) {
                style.sectionHeader(
                    LanguageManager.shared.localizedString(for: "ComposeTheTranslation")
                        .capitalizedFirstLetter
                )
                style.mainText(word.frontText)
                    .frame(maxWidth: .infinity)
                    .frame(height: GameCardStyle.Letters.wordSectionHeight)
                    .background(
                        RoundedRectangle(cornerRadius: GameCardStyle.Layout.cornerRadius)
                            .fill(style.theme.backgroundBlockColor)
                            .shadow(
                                color: style.theme.accentColor.opacity(0.1),
                                radius: GameCardStyle.Layout.shadowRadius,
                                x: 0,
                                y: GameCardStyle.Layout.shadowY
                            )
                    )
            }
            .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
        }
    }
    
    struct AnswerSection: View {
        let selectedLetters: [Character]
        let onTap: (Character) -> Void
        let style: GameCardStyle
        
        var body: some View {
            VStack(spacing: GameCardStyle.Layout.topPadding) {
                style.sectionHeader(
                    LanguageManager.shared.localizedString(for: "Word")
                        .capitalizedFirstLetter
                )
                CompGameLetterGridView(
                    letters: selectedLetters,
                    onTap: onTap,
                    style: .answer,
                    cardStyle: style
                )
                .frame(minHeight: GameCardStyle.Letters.answerSectionHeight)
                .background(
                    RoundedRectangle(cornerRadius: GameCardStyle.Layout.cornerRadius)
                        .stroke(style.theme.accentColor.opacity(0.2),
                               lineWidth: GameCardStyle.Layout.borderWidth)
                )
            }
        }
    }
    
    struct HintSection: View {
        let hint: String
        let hintState: GameHintState
        let style: GameCardStyle
        let onTap: () -> Void
        
        var body: some View {
            VStack {
                if hintState.isShowing {
                    style.hintContainer {
                        style.hintPenalty()
                        Text(hint)
                            .font(GameCardStyle.Typography.hintFont)
                            .foregroundColor(style.theme.secondaryTextColor)
                            .multilineTextAlignment(.center)
                    }
                }
                Button(action: onTap) {
                    style.hintButton(isActive: hintState.isShowing)
                }
            }
        }
    }
}
