import SwiftUI

struct ButtonMain: ViewModifier {
    var textColor: Color = .white
    var cornerRadius: CGFloat = 10
    var width: CGFloat = 200
    var height: CGFloat = 50
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .frame(width: width, height: height)
            .background(Color.blue)
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func buttonMain() -> some View {
        self.modifier(ButtonMain())
    }
}
