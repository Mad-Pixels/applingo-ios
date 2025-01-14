import SwiftUI

struct InputSearch: View {
    @Binding var text: String
    let placeholder: String
    let style: InputSearchStyle
    
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(style.iconColor)
                .font(.system(size: style.iconSize))
            
            TextField(placeholder, text: $text)
                .foregroundColor(style.textColor)
                .focused($isFocused)
                .padding(.vertical, 4)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(style.iconColor)
                        .font(.system(size: style.iconSize))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(style.padding)
        .background(Color.clear)
        .cornerRadius(style.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor, lineWidth: isFocused ? 3 : 1)
        )
        .shadow(color: style.shadowColor, radius: style.shadowRadius, x: style.shadowX, y: style.shadowY)
    }
}
