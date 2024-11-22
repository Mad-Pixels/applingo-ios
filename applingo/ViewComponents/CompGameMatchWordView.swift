import SwiftUI

struct CompGameMatchWordView: View {
    let word: WordItemModel
    let showTranslation: Bool
    let isSelected: Bool
    let isMatched: Bool
    let onTap: () -> Void
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    var body: some View {
        Button(action: {
            if !isMatched {
                onTap()
            }
        }) {
            wordContent
        }
        .buttonStyle(CompGameMatchButtonStyle(isSelected: isSelected, isMatched: isMatched))
    }
    
    private var wordContent: some View {
        Text(showTranslation ? word.backText : word.frontText)
            .font(.system(.body, design: .rounded).weight(.medium))
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 60)
    }
}

struct CompGameMatchButtonStyle: ButtonStyle {
    let isSelected: Bool
    let isMatched: Bool
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
            .background(backgroundColor(isPressed: configuration.isPressed))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderColor, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: shadowColor,
                radius: isSelected ? 5 : 2,
                x: 0,
                y: isSelected ? 2 : 1
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isMatched ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        if isMatched {
            return .gray
        }
        if isSelected {
            return .white
        }
        return style.theme.baseTextColor
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if isMatched {
            return style.theme.backgroundBlockColor.opacity(0.5)
        }
        if isSelected {
            return style.theme.accentColor
        }
        if isPressed {
            return style.theme.backgroundBlockColor.opacity(0.8)
        }
        return style.theme.backgroundBlockColor
    }
    
    private var borderColor: Color {
        if isMatched {
            return .gray.opacity(0.3)
        }
        if isSelected {
            return style.theme.accentColor
        }
        return style.theme.secondaryTextColor.opacity(0.3)
    }
    
    private var shadowColor: Color {
        isSelected ?
        style.theme.accentColor.opacity(0.3) :
        style.theme.secondaryTextColor.opacity(0.1)
    }
}
