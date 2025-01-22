import CoreMotion

final class HardwareMotion: ObservableObject {
    static let shared = HardwareMotion()
    
    @Published private(set) var roll: Double = 0
    @Published private(set) var pitch: Double = 0
    
    private let motionManager = CMMotionManager()
    private let updateInterval = 1.0 / 60.0 // 60 FPS
    
    private init() {
        startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion, error == nil else { return }
            
            self?.roll = motion.attitude.roll
            self?.pitch = motion.attitude.pitch
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
