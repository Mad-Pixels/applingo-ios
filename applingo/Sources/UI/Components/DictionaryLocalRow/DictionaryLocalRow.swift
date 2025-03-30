import SwiftUI

struct DictionaryLocalRow: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let model: DictionaryLocalRowModel
    let style: DictionaryLocalRowStyle
    let onTap: () -> Void
    let onToggle: (Bool) -> Void
    
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                VStack(alignment: .leading, spacing: style.spacing / 2) {
                    DynamicTextCompact(
                        model: DynamicTextModel(text: model.title),
                        style: .textBold(
                            themeManager.currentThemeStyle,
                            lineLimit: 6
                        )
                    )
                    
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
                        DynamicTextCompact(
                            model: DynamicTextModel(text: model.subtitle),
                            style: .textMain(
                                themeManager.currentThemeStyle,
                                lineLimit: 1,
                                color: style.subtitleColor
                            )
                        )
                    }
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "book")
                                .font(.system(size: 11))
                                .foregroundColor(style.accentColor)

                            Text(model.formattedWordCount)
                                .font(style.wordCountFont)
                                .foregroundColor(style.subtitleColor)
                        }
                        
                        if model.level.rawValue != "UFO" {
                            Text("|")
                                .font(style.wordCountFont)
                                .foregroundColor(style.subtitleColor.opacity(0.5))
                            
                            HStack(spacing: 4) {
                                Image(systemName: "graduationcap")
                                    .font(.system(size: 11))
                                    .foregroundColor(style.accentColor)
                                
                                Text(model.level.rawValue)
                                    .font(style.wordCountFont)
                                    .foregroundColor(style.subtitleColor)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ItemCheckbox(isChecked: .constant(model.isActive),
                           onChange: onToggle)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
