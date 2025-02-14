import CoreMotion
import SwiftUI

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

/// An observable class that manages and smooths motion data (roll and pitch) into X and Y offsets.
///
/// `MotionState` collects incoming roll and pitch values, clamps and normalizes them,
/// and then computes a smoothed average over a small buffer of previous values.
/// This smoothed data is used to update the X and Y offsets, which can be used
/// to drive UI animations or effects based on device motion.
final class MotionState: ObservableObject {
    // MARK: - Published Properties
    /// The current smoothed offset along the X axis.
    @Published var offsetX: CGFloat = 0
    /// The current smoothed offset along the Y axis.
    @Published var offsetY: CGFloat = 0
    
    // MARK: - Private Properties
    
    /// A buffer storing the recent normalized motion values for smoothing.
    private var previousValues: [(x: CGFloat, y: CGFloat)] = []
    /// The maximum number of previous values to store for smoothing calculations.
    private let maxPreviousValues = 4
    
    // MARK: - Methods
    
    /// Updates the motion state based on incoming roll and pitch values.
    ///
    /// This method clamps the raw roll and pitch values within the specified range,
    /// normalizes them to a scale of -1 to 1, and then adds the new values to a buffer.
    /// It calculates the average of the buffered values to produce smooth offsets.
    /// Finally, it updates the published offsets with a linear animation.
    ///
    /// - Parameters:
    ///   - roll: The roll value from the motion sensor.
    ///   - pitch: The pitch value from the motion sensor.
    ///   - range: The maximum absolute value for roll and pitch before normalization (default is 0.3).
    func updateMotion(roll: Double, pitch: Double, range: Double = 0.3) {
        let clampedRoll = min(max(roll, -range), range)
        let clampedPitch = min(max(pitch, -range), range)
        
        let normalizedX = CGFloat(clampedRoll / range)
        let normalizedY = CGFloat(clampedPitch / range)
        
        previousValues.append((normalizedX, normalizedY))
        if previousValues.count > maxPreviousValues {
            previousValues.removeFirst()
        }
        
        let averageX = previousValues.map { $0.x }.reduce(0, +) / CGFloat(previousValues.count)
        let averageY = previousValues.map { $0.y }.reduce(0, +) / CGFloat(previousValues.count)
        
        DispatchQueue.main.async {
            withAnimation(.linear(duration: 0.3)) {
                self.offsetX = averageX
                self.offsetY = averageY
            }
        }
    }
}
