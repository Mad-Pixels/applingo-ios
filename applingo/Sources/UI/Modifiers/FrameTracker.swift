import SwiftUI

struct FrameTracker: ViewModifier {
    let frame: AppFrameModel
    
    func body(content: Content) -> some View {
        content.onAppear {
            FrameManager.shared.setActiveFrame(frame)
        }
    }
}

extension View {
    func withFrameTracker(_ frame: AppFrameModel) -> some View {
        modifier(FrameTracker(frame: frame))
    }
}
