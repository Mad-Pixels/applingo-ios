import SwiftUI

struct WordRow_Previews: PreviewProvider {
   static var previews: some View {
       WordRowPreview()
           .previewDisplayName("Word Row Component")
           .previewLayout(.sizeThatFits)
           .padding()
   }
}

private struct WordRowPreview: View {
   var body: some View {
       ScrollView {
           VStack(spacing: 32) {
               previewSection("Light Theme", theme: LightTheme())
               previewSection("Dark Theme", theme: DarkTheme())
           }
           .padding()
           .frame(maxWidth: .infinity)
       }
   }
   
   private func previewSection(_ title: String, theme: AppTheme) -> some View {
       VStack(alignment: .leading, spacing: 20) {
           Text(title)
               .font(.headline)
               .foregroundColor(theme.textPrimary)
               .frame(maxWidth: .infinity, alignment: .leading)
           
           Group {
               // Low progress word
               VStack(alignment: .leading, spacing: 8) {
                   Text("Low progress")
                       .font(.subheadline)
                       .foregroundColor(theme.textSecondary)
                   
                   WordRow(
                        model: WordRowModel(
                           frontText: "Hello",
                           backText: "Привет",
                           weight: 250
                       ),
                       style: .themed(theme)
                   ) {
                       print("Tapped word with low progress")
                   }
                   .background(theme.backgroundSecondary)
                   .cornerRadius(12)
               }
               
               // Medium progress word
               VStack(alignment: .leading, spacing: 8) {
                   Text("Medium progress")
                       .font(.subheadline)
                       .foregroundColor(theme.textSecondary)
                   
                   WordRow(
                       model: WordRowModel(
                           frontText: "World",
                           backText: "Мир",
                           weight: 500
                       ),
                       style: .themed(theme)
                   ) {
                       print("Tapped word with medium progress")
                   }
                   .background(theme.backgroundSecondary)
                   .cornerRadius(12)
               }
               
               // High progress word
               VStack(alignment: .leading, spacing: 8) {
                   Text("High progress")
                       .font(.subheadline)
                       .foregroundColor(theme.textSecondary)
                   
                   WordRow(
                       model: WordRowModel(
                           frontText: "Example",
                           backText: "Пример",
                           weight: 850
                       ),
                       style: .themed(theme)
                   ) {
                       print("Tapped word with high progress")
                   }
                   .background(theme.backgroundSecondary)
                   .cornerRadius(12)
               }
               
               // Long text example
               VStack(alignment: .leading, spacing: 8) {
                   Text("Long text")
                       .font(.subheadline)
                       .foregroundColor(theme.textSecondary)
                   
                   WordRow(
                       model: WordRowModel(
                           frontText: "This is a very long text to test wrapping",
                           backText: "Это очень длинный текст для проверки переноса",
                           weight: 650
                       ),
                       style: .themed(theme)
                   ) {
                       print("Tapped word with long text")
                   }
                   .background(theme.backgroundSecondary)
                   .cornerRadius(12)
               }
           }
       }
       .padding()
       .background(theme.backgroundPrimary)
       .cornerRadius(12)
       .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
   }
}
