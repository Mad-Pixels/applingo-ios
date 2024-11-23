import SwiftUI

struct GameLetterGridStyle {
    static let columns = [
        GridItem(.adaptive(minimum: 50), spacing: 12)
    ]
    
    static let buttonSize: CGFloat = 50
    static let gridSpacing: CGFloat = 12
    static let gridPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 12
    
    static func backgroundColor(for style: GameLetterStyle) -> Color {
        switch style {
        case .option:
            return Color(.systemGray6)
        case .answer:
            return Color(.systemBackground)
        }
    }
    
    static func foregroundColor(for style: GameLetterStyle) -> Color {
        switch style {
        case .option:
            return Color(.label)
        case .answer:
            return .accentColor
        }
    }
    
    static var shadowColor: Color {
        Color(.systemGray).opacity(0.2)
    }
}
