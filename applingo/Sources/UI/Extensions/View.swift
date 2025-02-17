import SwiftUI

extension View {
    /// Adds an overlay with a centered modal window over the current view.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the modal is visible.
    ///   - style: An optional style for the modal window; if nil, the default themed style is applied.
    ///   - modalContent: A ViewBuilder closure that constructs the content of the modal window.
    /// - Returns: A view with an overlay containing the modal window, which appears at the center of the screen.
    func showModal<Content: View>(
        isPresented: Binding<Bool>,
        style: ModalWindowStyle? = nil,
        @ViewBuilder modalContent: @escaping () -> Content
    ) -> some View {
        self.overlay(
            ModalWindow(isPresented: isPresented, style: style, content: modalContent)
        )
    }
}
