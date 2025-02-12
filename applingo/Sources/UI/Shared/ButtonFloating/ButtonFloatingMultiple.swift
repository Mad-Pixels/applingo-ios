import SwiftUI

// MARK: - ButtonFloatingMultiple View
/// A floating button that expands to show multiple action buttons when tapped.
struct ButtonFloatingMultiple: View {
    let items: [ButtonFloatingModelIconAction]
    let style: ButtonFloatingStyle
   
    @State private var isOpen = false
    @State private var iconRotation: Double = 0

    /// Initializes the ButtonFloatingMultiple view.
    /// - Parameters:
    ///   - items: An array of model actions containing an icon and an action closure.
    ///   - style: The style for the floating button. Defaults to themed style.
    init(
        items: [ButtonFloatingModelIconAction],
        style: ButtonFloatingStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.items = items
        self.style = style
    }
   
    var body: some View {
        ZStack {
            if isOpen {
                Color.black.opacity(0.001)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.2)) {
                            isOpen = false
                            iconRotation = 0
                        }
                    }
                    .ignoresSafeArea()
            }
           
            ZStack(alignment: .bottomTrailing) {
                if isOpen {
                    VStack(spacing: style.spacing) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7,  blendDuration: 0.2)) {
                                    isOpen = false
                                    iconRotation = 0
                                }
                                items[index].action()
                            }) {
                                Image(systemName: items[index].icon)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .frame(width: style.itemButtonSize.width, height: style.itemButtonSize.height)
                                    .background(style.itemButtonColor)
                                    .cornerRadius(style.cornerRadius)
                                    .shadow(color: style.shadowColor, radius: style.shadowRadius)
                            }
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                    .padding(.bottom, style.mainButtonSize.height + style.spacing)
                }
               
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isOpen.toggle()
                        iconRotation += 180
                    }
                }) {
                    Image(systemName: isOpen ? "xmark" : "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .frame(width: style.mainButtonSize.width, height: style.mainButtonSize.height)
                        .background(style.mainButtonColor)
                        .cornerRadius(style.cornerRadius)
                        .shadow(color: style.shadowColor, radius: style.shadowRadius)
                        .rotationEffect(.degrees(iconRotation))
                        .scaleEffect(isOpen ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.4), value: isOpen)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
    }
}
