import SwiftUI

#Preview("Game Mode Screen") {
   ScreenGameMode(
       selectedMode: .constant(.practice),
       startGame: {}
   )
   .environmentObject(ThemeManager.shared)
   .environmentObject(LocaleManager.shared)
}

struct ScreenGameMode_Previews: PreviewProvider {
   static var previews: some View {
       Group {
           // Light theme
           ScreenGameMode(
               selectedMode: .constant(.practice),
               startGame: {}
           )
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.light)
           
           // Dark theme
           ScreenGameMode(
               selectedMode: .constant(.practice),
               startGame: {}
           )
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.dark)
       }
   }
}
