import SwiftUI

struct DictionaryRow: View {
    let title: String
    let subtitle: String
    let isActive: Bool
    let style: DictionaryRowStyle
    let onTap: () -> Void
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
                
                Text(subtitle)
                    .font(style.subtitleFont)
                    .foregroundColor(style.subtitleColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(style.padding)
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            
            ItemCheckbox(
                isChecked: .constant(isActive),
                onChange: onToggle
            )
        }
        .background(style.backgroundColor)
    }
}
