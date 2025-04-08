import SwiftUI

struct ButtonFloatingMultiple: View {
    let items: [ButtonFloatingModelIconAction]
    let style: ButtonFloatingStyle
   
    @State private var iconRotation: Double = 0
    @State private var itemsScale: [Double]
    @State private var isAnimating = false
    @State private var isOpen = false
    

    /// Initializes the ButtonFloatingMultiple.
    /// - Parameters:
    ///   - items: An array of model actions containing an icon and an action closure.
    ///   - style: The style for the floating button. Defaults to themed style.
    init(
        items: [ButtonFloatingModelIconAction],
        style: ButtonFloatingStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.items = items
        self.style = style
        self._itemsScale = State(initialValue: Array(repeating: 0.0, count: items.count))
    }
   
    var body: some View {
        ZStack {
            if isOpen {
                Color.black.opacity(0.001)
                    .onTapGesture {
                        if !isAnimating {
                            closeMenu()
                        }
                    }
                    .ignoresSafeArea()
            }
           
            ZStack(alignment: .bottomTrailing) {
                if isOpen {
                    VStack(spacing: style.spacing) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Button(action: {
                                if !isAnimating {
                                    closeMenu()
                                    items[index].action()
                                }
                            }) {
                                Image(systemName: items[index].icon)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(width: style.itemButtonSize.width, height: style.itemButtonSize.height)
                                    .background(
                                        ZStack {
                                            Circle()
                                                .fill(style.itemButtonColor)

                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            style.itemButtonColor.opacity(0.7),
                                                            style.itemButtonColor
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                            
                                            Circle()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                                .padding(1)
                                        }
                                    )
                                    .shadow(color: style.shadowColor, radius: style.shadowRadius)
                                    .cornerRadius(style.cornerRadius)
                                    .scaleEffect(itemsScale[index])
                            }
                            .onAppear {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(Double(index) * 0.05)) {
                                    itemsScale[index] = 1.0
                                }
                            }
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                    .padding(.bottom, style.mainButtonSize.height + style.spacing)
                }
               
                Button(action: {
                    if !isAnimating {
                        if isOpen {
                            closeMenu()
                        } else {
                            openMenu()
                        }
                    }
                }) {
                    Image(systemName: isOpen ? "xmark" : "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .frame(width: style.mainButtonSize.width, height: style.mainButtonSize.height)
                        .background(
                            ZStack {
                                Circle()
                                    .fill(style.mainButtonColor)
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                style.mainButtonColor.opacity(0.8),
                                                style.mainButtonColor
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                    .padding(1)
                            }
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .padding(2)
                        )
                        .shadow(color: style.shadowColor, radius: style.shadowRadius)
                        .rotationEffect(.degrees(iconRotation))
                        .scaleEffect(isOpen ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.4), value: isOpen)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 16)
            .padding(.bottom, 18)
        }
    }
    
    /// open implementation.
    private func openMenu() {
        isAnimating = true
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isOpen = true
            iconRotation += 180
        }
        for i in 0..<itemsScale.count {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(Double(i) * 0.05)) {
                itemsScale[i] = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(itemsScale.count) * 0.05) {
            isAnimating = false
        }
    }
    
    /// close implementation.
    private func closeMenu() {
        isAnimating = true
        for i in 0..<itemsScale.count {
            withAnimation(.easeInOut(duration: 0.2).delay(Double(itemsScale.count - i - 1) * 0.05)) {
                itemsScale[i] = 0.0
            }
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.2).delay(0.1)) {
            isOpen = false
            iconRotation = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + 0.1) {
            isAnimating = false
        }
    }
}
