import SwiftUI

struct GameMatchHuntView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            Text("Hello World from Match Hunt!")
                .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
        }
    }
}
