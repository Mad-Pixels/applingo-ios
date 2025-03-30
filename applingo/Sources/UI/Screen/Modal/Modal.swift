import SwiftUI

struct ModalWindow<Content: View>: View {
    @StateObject private var style: ModalStyle

    @Binding private var isPresented: Bool
    
    private let content: Content

    /// Initializes the ModalWindow.
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the modal is visible.
    ///   - style: An optional modal window style; if nil, a default themed style is applied.
    ///   - content: A ViewBuilder that provides the content to be displayed in the modal.
    init(
        isPresented: Binding<Bool>,
        style: ModalStyle = .themed(ThemeManager.shared.currentThemeStyle),
        @ViewBuilder content: () -> Content
    ) {
        _style = StateObject(wrappedValue: style)
        _isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                style.dimBackgroundColor
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                content
                    .padding(style.padding)
                    .frame(width: style.windowWidth, height: style.windowHeight)
                    .background(
                        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                            .fill(style.modalBackgroundColor)
                    )
                    .shadow(radius: style.shadowRadius)
                    .transition(.asymmetric(
                        insertion: AnyTransition.scale.combined(with: .opacity),
                        removal: AnyTransition.scale.combined(with: .opacity)
                    ))
            }
        }
        .zIndex(isPresented ? 100 : 0)
        .animation(style.animation, value: isPresented)
    }
}
