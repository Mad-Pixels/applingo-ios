import CoreMotion
import SwiftUI

/// Manages hardware motion updates using CoreMotion.
final class HardwareMotion: ObservableObject {
    static let shared = HardwareMotion()
    
    @Published private(set) var roll: Double = 0
    @Published private(set) var pitch: Double = 0
    
    private let motionManager = CMMotionManager()
    private let updateInterval = 1.0 / 60.0
    
    private init() {
        startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            Logger.debug("[Hardware]: Device motion unavailable")
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
    @Published var offsetX: CGFloat = 0
    @Published var offsetY: CGFloat = 0
    
    private var previousValues: [(x: CGFloat, y: CGFloat)] = []
    private let maxPreviousValues = 4
    private var updateWorkItem: DispatchWorkItem?
    
    func updateMotion(roll: Double, pitch: Double, range: Double = 0.3) {
        updateWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            let clampedRoll = min(max(roll, -range), range)
            let clampedPitch = min(max(pitch, -range), range)
            
            let normalizedX = CGFloat(clampedRoll / range)
            let normalizedY = CGFloat(clampedPitch / range)
            
            self.previousValues.append((normalizedX, normalizedY))
            if self.previousValues.count > self.maxPreviousValues {
                self.previousValues.removeFirst()
            }
            
            let averageX = self.previousValues.map { $0.x }.reduce(0, +) / CGFloat(self.previousValues.count)
            let averageY = self.previousValues.map { $0.y }.reduce(0, +) / CGFloat(self.previousValues.count)
            
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.3)) {
                    self.offsetX = averageX
                    self.offsetY = averageY
                }
            }
        }
        
        updateWorkItem = workItem
        DispatchQueue.main.async(execute: workItem)
    }
}
