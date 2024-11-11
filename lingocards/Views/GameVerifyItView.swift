import SwiftUI

struct GameVerifyItView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            Text("Hello World from Verify It!")
                .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
        }
    }
}
