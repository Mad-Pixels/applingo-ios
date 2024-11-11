import SwiftUI

struct GameQuizView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            Text("Hello World from Quiz!")
                .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
        }
    }
}
