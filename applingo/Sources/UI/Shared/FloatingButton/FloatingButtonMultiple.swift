import SwiftUI

struct IconAction {
    let icon: String
    let action: () -> Void
}

struct FloatingButtonMultiple: View {
    let items: [IconAction]
    let style: FloatingButtonStyle
    
    @State private var isOpen = false
    
    init(
        items: [IconAction],
        style: FloatingButtonStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.items = items
        self.style = style
    }
    
    var body: some View {
        ZStack {
            if isOpen {
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
            }
            
            ZStack(alignment: .bottomTrailing) {
                if isOpen {
                    VStack(spacing: style.spacing) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    isOpen = false
                                }
                                items[index].action()
                            }) {
                                Image(systemName: items[index].icon)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .frame(
                                        width: style.itemButtonSize.width,
                                        height: style.itemButtonSize.height
                                    )
                                    .background(style.itemButtonColor)
                                    .cornerRadius(style.cornerRadius)
                                    .shadow(
                                        color: style.shadowColor,
                                        radius: style.shadowRadius
                                    )
                            }
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                    .padding(.bottom, style.mainButtonSize.height + style.spacing)
                }

                Button(action: {
                    withAnimation {
                        isOpen.toggle()
                    }
                }) {
                    Image(systemName: isOpen ? "xmark" : "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .frame(
                            width: style.mainButtonSize.width,
                            height: style.mainButtonSize.height
                        )
                        .background(style.mainButtonColor)
                        .cornerRadius(style.cornerRadius)
                        .shadow(
                            color: style.shadowColor,
                            radius: style.shadowRadius
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
    }
}
