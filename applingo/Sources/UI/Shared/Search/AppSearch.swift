import SwiftUI

struct AppSearch: View {
    @Binding var text: String
    let placeholder: String
    let style: AppSearchStyle
    let onChange: ((String) -> Void)?
    
    init(
        text: Binding<String>,
        placeholder: String,
        style: AppSearchStyle = .themed(ThemeManager.shared.currentThemeStyle),
        onChange: ((String) -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.onChange = onChange
    }
    
    var body: some View {
        HStack(spacing: style.spacing) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: style.iconSize))
                .foregroundColor(style.iconColor)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(style.placeholderColor)
                }
                
                TextField("", text: Binding(
                    get: { text },
                    set: { newValue in
                        text = newValue
                        onChange?(newValue)
                    }
                ))
                .foregroundColor(style.textColor)
            }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onChange?("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: style.iconSize))
                        .foregroundColor(style.iconColor)
                }
            }
        }
        .padding(style.padding)
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
    }
}
