//import SwiftUI
//
//#Preview("Word Row") {
//   WordRowPreview()
//}
//
//private struct WordRowPreview: View {
//   var body: some View {
//       ScrollView {
//           VStack(spacing: 32) {
//               previewSection("Light Theme", theme: LightTheme())
//               previewSection("Dark Theme", theme: DarkTheme())
//           }
//           .padding()
//       }
//   }
//   
//   private func previewSection(_ title: String, theme: AppTheme) -> some View {
//       VStack(alignment: .leading, spacing: 20) {
//           Text(title)
//               .font(.headline)
//           
//           // Regular state
//           VStack(alignment: .leading, spacing: 8) {
//               Text("Regular state")
//                   .font(.subheadline)
//                   .foregroundColor(theme.textSecondary)
//               
//               WordRow(
//                   word: WordModel(
//                    frontText: "Hello",
//                    backText: "Привет",
//                    weight: 300,
//                   ),
//                   style: .themed(theme),
//                   onTap: { print("Tapped") }
//               )
//           }
//           
//           // Long text
//           VStack(alignment: .leading, spacing: 8) {
//               Text("Long text")
//                   .font(.subheadline)
//                   .foregroundColor(theme.textSecondary)
//               
//               WordRow(
//                   frontText: "This is a very long text that should wrap",
//                   backText: "Это очень длинный текст",
//                   style: .themed(theme),
//                   onTap: { print("Tapped") }
//               )
//           }
//           
//           // Disabled state
//           VStack(alignment: .leading, spacing: 8) {
//               Text("Disabled state")
//                   .font(.subheadline)
//                   .foregroundColor(theme.textSecondary)
//               
//               WordRow(
//                   frontText: "Disabled",
//                   backText: "Отключено",
//                   style: .themed(theme),
//                   onTap: { }
//               )
//               .disabled(true)
//           }
//       }
//       .padding()
//       .background(theme.backgroundPrimary)
//   }
//}
