import SwiftUI

struct DictionaryRow: View {
    let title: String
    let subtitle: String
    let isActive: Bool
    let style: DictionaryRowStyle
    let onTap: () -> Void
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: style.spacing) {
            VStack(alignment: .leading, spacing: style.spacing / 2) {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
                
                Text(subtitle)
                    .font(style.subtitleFont)
                    .foregroundColor(style.subtitleColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ItemCheckbox(
                isChecked: .constant(isActive),
                onChange: onToggle
            )
        }
        .padding(.horizontal, style.spacing)
        .padding(.vertical, style.spacing * 0.75)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.backgroundColor)
                .shadow(
                    color: style.shadowColor.opacity(0.1),
                    radius: style.shadowRadius,
                    x: 0,
                    y: 2
                )
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
