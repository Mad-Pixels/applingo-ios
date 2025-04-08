import CoreHaptics
import SwiftUI

/// Manages haptic feedback using `CoreHaptics` and `UIKit`.
final class HardwareHaptic {
    // MARK: - Singleton Instance
    
    /// Shared singleton instance for accessing `HardwareHaptic`.
    static let shared = HardwareHaptic()
    
    // MARK: - Private Properties
    
    /// Haptic engine for generating haptic patterns.
    private var engine: CHHapticEngine?
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton usage.
    private init() {
        setupEngine()
    }
    
    // MARK: - Engine Setup
    
    /// Configures and starts the haptic engine if the hardware supports haptics.
    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            Logger.warning("[Hardware]: Haptics not supported on this device")
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            Logger.debug("[Hardware]: Haptic engine initialized successfully")
        } catch {
            Logger.error(
                "[Hardware]: Haptic engine initialization failed",
                metadata: ["error": error.localizedDescription]
            )
        }
    }
    
    // MARK: - Play Haptic Pattern
    
    /// Plays a haptic pattern with the specified intensity, sharpness, and repeat count.
    /// - Parameters:
    ///   - intensity: Intensity of the haptic feedback (0.0 - 1.0).
    ///   - sharpness: Sharpness of the haptic feedback (0.0 - 1.0).
    ///   - count: Number of times the pattern should repeat. Defaults to 1.
    func playHapticPattern(intensity: Float, sharpness: Float, count: Int = 1) {
        // Fallback to simple feedback if `CoreHaptics` is unavailable
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else {
            Logger.warning("[Hardware]: Haptics not supported or engine unavailable")
            return
        }
        
        do {
            var events: [CHHapticEvent] = []
            
            // Create haptic events with a time offset for each repetition
            for i in 0..<count {
                let timeOffset = TimeInterval(i) * 0.1
                let intensityParameter = CHHapticEventParameter(
                    parameterID: .hapticIntensity,
                    value: intensity
                )
                let sharpnessParameter = CHHapticEventParameter(
                    parameterID: .hapticSharpness,
                    value: sharpness
                )
                
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensityParameter, sharpnessParameter],
                    relativeTime: timeOffset
                )
                events.append(event)
            }
            
            // Create and play the haptic pattern
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            
            Logger.debug(
                "[Hardware]: Played haptic pattern",
                metadata: ["intensity": intensity, "sharpness": sharpness, "count": count]
            )
        } catch {
            Logger.warning(
                "[Hardware]: Failed to play haptic pattern",
                metadata: ["error": error.localizedDescription]
            )
        }
    }
}
