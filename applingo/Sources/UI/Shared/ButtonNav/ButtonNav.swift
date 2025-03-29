import SwiftUI

struct ButtonNav: View {
    let style: ButtonNavStyle
    let onTap: () -> Void
    @Binding var isPressed: Bool
    
    var body: some View {
        Group {
            switch style.icon {
            case .system(let name):
                Image(systemName: name)
                    .font(.system(size: style.iconSize, weight: .semibold))
            case .custom(let assetName):
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .foregroundColor(style.iconColor)
        .frame(width: style.size, height: style.size)
        .background(
            Circle()
                .fill(style.backgroundColor)
                .opacity(isPressed ? 0.7 : 1)
        )
        .overlay(
            Circle()
                .stroke(isPressed ? style.iconColor : .clear, lineWidth: 3)
        )
        .clipShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            onTap()
                        }
                    }
                }
        )
    }
}
