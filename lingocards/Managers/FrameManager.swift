import Foundation
import Combine

final class FrameManager: ObservableObject {
    @Published var activeFrame: AppFrameModel = .learn
    static let shared = FrameManager()

    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[FrameManager]: Initialized")
    }

    func setActiveFrame(_ frame: AppFrameModel) {
        DispatchQueue.main.async {
            self.activeFrame = frame
            Logger.debug("[FrameManager]: Activate frame \(frame.rawValue)")
        }
    }
    
    func deactivateFrame(_ frame: AppFrameModel) {
        if activeFrame == frame {
            DispatchQueue.main.async {
                self.activeFrame = .learn
                Logger.debug("[FrameManager]: Deactivate frame \(frame.rawValue)")
                
                self.clearErrors(for: frame)
            }
        }
    }
    
    func isActive(frame: AppFrameModel) -> Bool {
        return activeFrame == frame
    }

    private func clearErrors(for frame: AppFrameModel) {
        ErrorManager.shared.clearErrors(for: frame)
        Logger.debug("[FrameManager]: Cleared errors for \(frame.rawValue)")
    }
}
