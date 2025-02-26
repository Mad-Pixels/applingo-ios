import SwiftUI

struct WordRow: View {
    let model: WordRowModel
    let style: WordRowStyle
    let onTap: () -> Void
    
    init(
        model: WordRowModel,
        style: WordRowStyle = .themed(ThemeManager.shared.currentThemeStyle),
        onTap: @escaping () -> Void
    ) {
        self.model = model
        self.style = style
        self.onTap = onTap
    }
    
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                VStack(alignment: .leading, spacing: style.spacing / 2) {
                    Text(model.frontText)
                        .foregroundColor(style.frontTextColor)
                        .font(style.frontTextFont)
                    
                    Text(model.backText)
                        .font(style.backTextFont)
                        .foregroundColor(style.backTextColor)
                    
                    HStack(spacing: style.spacing / 2) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 12))
                            .foregroundColor(style.arrowColor)
                        
                        ChartIndicator(weight: model.weight)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: style.arrowSize))
                    .foregroundColor(style.arrowColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
