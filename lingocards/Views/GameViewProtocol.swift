import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

struct BaseGameView<Content: View>: View {
    let isPresented: Binding<Bool>
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            ThemeManager.shared.currentThemeStyle.backgroundViewColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented.wrappedValue = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
                    }
                    .padding()
                }
                content
                
                Spacer()
            }
        }
    }
}
