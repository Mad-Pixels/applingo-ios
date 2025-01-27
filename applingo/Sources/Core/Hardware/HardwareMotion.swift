import CoreMotion

/// Manages hardware motion updates using CoreMotion.
final class HardwareMotion: ObservableObject {
    // MARK: - Singleton Instance
    
    /// Shared singleton instance for accessing `HardwareMotion`.
    static let shared = HardwareMotion()
    
    // MARK: - Published Properties
    
    /// The roll value of the device.
    @Published private(set) var roll: Double = 0
    
    /// The pitch value of the device.
    @Published private(set) var pitch: Double = 0
    
    // MARK: - Private Properties
    
    /// CoreMotion manager for accessing motion data.
    private let motionManager = CMMotionManager()
    
    /// Interval for updating motion data, set to 60 frames per second.
    private let updateInterval = 1.0 / 60.0
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton usage.
    private init() {
        startMotionUpdates()
    }
    
    // MARK: - Motion Updates
    
    /// Starts listening to device motion updates and updates roll/pitch values.
    private func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            Logger.debug(
                "[Hardware]: Device motion unavailable"
            )
            return
        }
        
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            if let error = error {
                Logger.error(
                    "[Hardware]: Failed to start motion updates",
                    metadata: ["error": error.localizedDescription]
                )
                return
            }
            
            guard let motion = motion else {
                Logger.debug("[Hardware]: Motion data is nil")
                return
            }
            
            self?.roll = motion.attitude.roll
            self?.pitch = motion.attitude.pitch
        }
        
        Logger.debug("[Hardware]: Started motion updates")
    }
    
    // MARK: - Deinitialization
    
    /// Stops motion updates when the instance is deallocated.
    deinit {
        motionManager.stopDeviceMotionUpdates()
        Logger.debug("[Hardware]: Stopped motion updates")
    }
}
