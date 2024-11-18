import SwiftUI

struct CompGameQuizCardView: View {
    let question: GameQuizCardModel
    let cardState: QuizCardState
    let hintState: GameHintState
    let style: GameCardStyle
    let specialService: GameSpecialService
    let onOptionSelected: (WordItemModel) -> Void
    let onHintTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            questionSection
            Spacer()
            optionsSection
            Spacer()
            
            if let hint = question.hintText {
                hintSection(hint)
            }
        }
        .gameCardStyle(style)
        .gameCardSpecialEffects(
            style: style,
            isSpecial: question.isSpecial,
            specialService: specialService
        )
    }
    
    private var questionSection: some View {
        VStack() {
            style.mainText(question.questionText)
                .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
        }
    }
    
    private var optionsSection: some View {
        VStack(spacing: 12) {
            ForEach(question.options) { option in
                optionButton(for: option)
            }
        }
        .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
    }
    
    private func optionButton(for option: WordItemModel) -> some View {
        Button(action: { onOptionSelected(option) }) {
            HStack {
                Text(optionText(for: option))
                    .font(GameCardStyle.Typography.titleFont)
                    .foregroundColor(getTextColor(for: option))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(getBackgroundColor(for: option))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(getBorderColor(for: option), lineWidth: cardState.selectedOptionId == option.id ? 2 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(cardState.isInteractionDisabled)
    }
    
    private func hintSection(_ hint: String) -> some View {
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
            
            Button(action: onHintTap) {
                style.hintButton(isActive: hintState.isShowing)
            }
            .disabled(hintState.wasUsed && hintState.isShowing)
            .padding(.bottom, 20)
        }
    }
    
    private func getTextColor(for option: WordItemModel) -> Color {
        if cardState.selectedOptionId == nil {
            return cardState.selectedOptionId == option.id ? .white : Color(.label)
        } else {
            return question.correctAnswer.id == option.id ? .white : Color(.label)
        }
    }
    
    private func getBackgroundColor(for option: WordItemModel) -> Color {
        if cardState.selectedOptionId == nil {
            return cardState.selectedOptionId == option.id ? .accentColor : Color(.systemBackground)
        } else {
            if question.correctAnswer.id == option.id {
                return .green
            } else if cardState.selectedOptionId == option.id {
                return .red
            } else {
                return Color(.systemBackground)
            }
        }
    }
    
    private func getBorderColor(for option: WordItemModel) -> Color {
        if cardState.selectedOptionId == nil {
            return cardState.selectedOptionId == option.id ? .clear : Color(.separator)
        } else {
            if question.correctAnswer.id == option.id {
                return .green
            } else if cardState.selectedOptionId == option.id {
                return .red
            } else {
                return Color(.separator)
            }
        }
    }
    
    private func optionText(for option: WordItemModel) -> String {
        question.isReversed ? option.frontText : option.backText
    }
}
