import SwiftUI

struct DictionaryRemoteRow: View {
    let model: DictionaryRemoteRowModel
    let style: DictionaryRemoteRowStyle
    let onTap: () -> Void
    let onToggle: (Bool) -> Void
    
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                VStack(alignment: .leading, spacing: style.spacing / 2) {
                    Text(model.title)
                        .font(style.titleFont)
                        .foregroundColor(style.titleColor)
                    
                    if let pair = model.languagePair {
                        HStack(spacing: 4) {
                            FlagIcon(code: pair.from,
                                   style: .themed(ThemeManager.shared.currentThemeStyle))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11))
                                .foregroundColor(style.subtitleColor)
                            FlagIcon(code: pair.to,
                                   style: .themed(ThemeManager.shared.currentThemeStyle))
                        }
                    } else {
                        Text(model.subtitle)
                            .font(style.subtitleFont)
                            .foregroundColor(style.subtitleColor)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 11))
                            .foregroundColor(style.accentColor)
                        
                        Text(model.formattedWordCount)
                            .font(style.wordCountFont)
                            .foregroundColor(style.subtitleColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
