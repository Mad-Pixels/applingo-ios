import SwiftUI

struct GameLearnView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            Text("Hello World from Learn!")
                .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
        }
    }
}
