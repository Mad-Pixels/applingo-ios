import SwiftUI

struct OverlayIcon: View {
    @State private var icon: String?
    @State private var color: Color = .clear
    @State private var isVisible = false

    let style: OverlayIconStyle

    init(style: OverlayIconStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }

    var body: some View {
        ZStack {
            if isVisible, let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: style.iconSize, weight: style.iconWeight))
                    .foregroundColor(color)
                    .opacity(style.iconOpacity)
                    .shadow(radius: style.shadowRadius)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(NotificationCenter.default.publisher(for: .visualIconFeedbackShouldUpdate)) { notification in
            guard
                let userInfo = notification.userInfo,
                let icon = userInfo["icon"] as? String,
                let color = userInfo["color"] as? Color,
                let duration = userInfo["duration"] as? TimeInterval
            else {
                return
            }

            self.icon = icon
            self.color = color
            withAnimation(style.animation) {
                self.isVisible = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation(style.animation) {
                    self.isVisible = false
                }
            }
        }
    }
}
