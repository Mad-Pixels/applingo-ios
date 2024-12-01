import SwiftUI

struct CompGameQuizCardView: View {
    @ObservedObject private var languageManager = LanguageManager.shared

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

    private func isCorrectOption(_ option: WordItemModel) -> Bool {
        let optionText = question.isReversed ? option.frontText : option.backText
        let correctText = question.isReversed ? question.correctAnswer.frontText : question.correctAnswer.backText
        
        let optionVariants = optionText
            .lowercased()
            .split(separator: "|")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        let correctVariants = correctText
            .lowercased()
            .split(separator: "|")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        return !Set(optionVariants).intersection(correctVariants).isEmpty
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
            .padding(.bottom, GameCardStyle.Layout.verticalPadding)
        }
    }
    
    private func optionButton(for option: WordItemModel) -> some View {
        Button(action: { onOptionSelected(option) }) {
            Text(optionText(for: option))
                .font(GameCardStyle.Typography.titleFont)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .modifier(
                    GameCardStyle.QuizOption.optionStyle(
                        isSelected: cardState.selectedOptionId == option.id,
                        isCorrect: (cardState.selectedOptionId == option.id && isCorrectOption(option)) ||
                                  (cardState.showCorrectAnswer && isCorrectOption(option)),
                        isAnswered: cardState.selectedOptionId != nil,
                        theme: style.theme
                    )
                )
                .animation(.easeInOut(duration: GameCardStyle.Layout.Animation.defaultDuration), value: cardState.selectedOptionId)
                .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(cardState.isInteractionDisabled)
    }
    
    private func optionText(for option: WordItemModel) -> String {
        question.isReversed ? option.frontText : option.backText
    }
}

extension GameCardStyle {
    struct QuizOption {
        static let height: CGFloat = 56
        static let cornerRadius: CGFloat = 12
        
        static func optionStyle(
            isSelected: Bool,
            isCorrect: Bool,
            isAnswered: Bool,
            theme: ThemeStyle
        ) -> some ViewModifier {
            OptionStyleModifier(
                theme: theme,
                isSelected: isSelected,
                isCorrect: isCorrect,
                isAnswered: isAnswered
            )
        }
    }
}

private struct OptionStyleModifier: ViewModifier {
    let theme: ThemeStyle
    let isSelected: Bool
    let isCorrect: Bool
    let isAnswered: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: GameCardStyle.QuizOption.height)
            .background(backgroundColor)
            .cornerRadius(GameCardStyle.QuizOption.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: GameCardStyle.QuizOption.cornerRadius)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: shadowColor,
                radius: isSelected ? 5 : 2,
                x: 0,
                y: isSelected ? 2 : 1
            )
    }
    
    private var foregroundColor: Color {
        if !isAnswered {
            return isSelected ? .white : theme.baseTextColor
        } else {
            return isCorrect ? .white : theme.baseTextColor
        }
    }
    
    private var backgroundColor: Color {
        if !isAnswered {
            return isSelected ? theme.accentColor : theme.backgroundBlockColor
        } else {
            if isCorrect {
                return theme.okTextColor
            } else if isSelected {
                return theme.errorTextColor
            } else {
                return theme.backgroundBlockColor
            }
        }
    }
    
    private var borderColor: Color {
        if !isAnswered {
            return isSelected ? .clear : theme.secondaryTextColor.opacity(0.3)
        } else {
            if isCorrect {
                return theme.okTextColor
            } else if isSelected {
                return theme.errorTextColor
            } else {
                return theme.secondaryTextColor.opacity(0.3)
            }
        }
    }
    
    private var shadowColor: Color {
        if !isAnswered {
            return isSelected ?
                theme.accentColor.opacity(0.3) :
                theme.secondaryTextColor.opacity(0.1)
        } else {
            if isCorrect {
                return theme.okTextColor.opacity(0.3)
            } else if isSelected {
                return theme.errorTextColor.opacity(0.3)
            } else {
                return theme.secondaryTextColor.opacity(0.1)
            }
        }
    }
}
