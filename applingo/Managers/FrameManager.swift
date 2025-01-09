//import Foundation
//import Combine
//
//final class FrameManager: ObservableObject {
//    @Published var activeFrame: AppFrameModel = .learn
//    static let shared = FrameManager()
//
//    private var cancellables = Set<AnyCancellable>()
//
//    private init() {
//        Logger.debug("[FrameManager]: Initialized")
//    }
//
//    func setActiveFrame(_ frame: AppFrameModel) {
//        if activeFrame != frame {
//            activeFrame = frame
//            Logger.debug("[FrameManager]: Activated frame \(frame.rawValue)")
//        }
//    }
//    
//    func deactivateFrame(_ frame: AppFrameModel) {
//        if activeFrame == frame {
//            self.activeFrame = .learn
//            Logger.debug("[FrameManager]: Deactivated frame \(frame.rawValue)")
//            
//            self.clearErrors(for: frame)
//        }
//    }
//    
//    func isActive(frame: AppFrameModel) -> Bool {
//        return activeFrame == frame
//    }
//
//    private func clearErrors(for frame: AppFrameModel) {
//        ErrorManager1.shared.clearErrors(for: frame)
//        Logger.debug("[FrameManager]: Cleared errors for \(frame.rawValue)")
//    }
//}
