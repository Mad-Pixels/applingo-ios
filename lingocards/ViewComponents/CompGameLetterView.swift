import SwiftUI

struct CompGameLetterGridView: View {
    let letters: [Character]
    let onTap: (Character) -> Void
    let style: GameLetterStyle
    
    var body: some View {
        LazyVGrid(columns: GameLetterGridStyle.columns, spacing: GameLetterGridStyle.gridSpacing) {
            ForEach(letters, id: \.self) { letter in
                CompGameLetterButton(letter: letter, style: style, onTap: onTap)
            }
        }
        .padding(GameLetterGridStyle.gridPadding)
    }
}

struct CompGameLetterButton: View {
    let letter: Character
    let style: GameLetterStyle
    let onTap: (Character) -> Void
    
    var body: some View {
        Button(action: { onTap(letter) }) {
            Text(String(letter))
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .frame(width: GameLetterGridStyle.buttonSize, height: GameLetterGridStyle.buttonSize)
                .background(GameLetterGridStyle.backgroundColor(for: style))
                .foregroundColor(GameLetterGridStyle.foregroundColor(for: style))
                .clipShape(RoundedRectangle(cornerRadius: GameLetterGridStyle.cornerRadius))
                .shadow(
                    color: GameLetterGridStyle.shadowColor,
                    radius: 2,
                    x: 0,
                    y: 1
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct CompGameLetterContentSections {
    struct WordSection: View {
        let word: WordItemModel
        let style: GameCardStyle
        
        var body: some View {
            VStack(spacing: 12) {
                Text(LanguageManager.shared.localizedString(for: "ComposeTheTranslation").capitalizedFirstLetter)
                    .font(GameCardStyle.Typography.captionFont)
                    .foregroundColor(style.theme.secondaryTextColor)
                Text(word.frontText)
                    .font(GameCardStyle.Typography.mainTextFont)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(style.theme.backgroundBlockColor)
                            .shadow(
                                color: style.theme.accentColor.opacity(0.1),
                                radius: 5,
                                x: 0,
                                y: 2
                            )
                    )
            }
        }
    }
    
    struct AnswerSection: View {
        let selectedLetters: [Character]
        let onTap: (Character) -> Void
        let style: GameCardStyle
        
        var body: some View {
            VStack(spacing: 16) {
                Text(LanguageManager.shared.localizedString(for: "Word").capitalizedFirstLetter)
                    .font(GameCardStyle.Typography.captionFont)
                    .foregroundColor(style.theme.secondaryTextColor)
                CompGameLetterGridView(
                    letters: selectedLetters,
                    onTap: onTap,
                    style: .answer
                )
                .frame(minHeight: 100)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style.theme.accentColor.opacity(0.2), lineWidth: 1)
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
