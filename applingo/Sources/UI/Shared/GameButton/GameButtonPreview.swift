import SwiftUI

#Preview("Game Button") {
   GameButtonPreview()
}

private struct GameButtonPreview: View {
   var body: some View {
       ScrollView {
           VStack(spacing: 32) {
               previewSection("Light Theme", theme: LightTheme())
               previewSection("Dark Theme", theme: DarkTheme())
           }
           .padding()
       }
   }
   
   private func previewSection(_ title: String, theme: AppTheme) -> some View {
       VStack(alignment: .leading, spacing: 20) {
           Text(title)
               .font(.headline)
           
           // Default
           GameButton(
               title: "Play Game",
               icon: "gamecontroller.fill",
               style: .themed(theme, color: theme.accentPrimary)
           )
           
           // Custom color
           GameButton(
               title: "Settings",
               icon: "gearshape.fill",
               color: theme.success,
               style: .themed(theme, color: theme.success)
           )
           
           // Disabled state
           GameButton(
               title: "Disabled",
               icon: "xmark.circle.fill",
               color: theme.error,
               style: .themed(theme, color: theme.error)
           )
           .disabled(true)
       }
       .padding()
       .background(theme.backgroundPrimary)
   }
}
