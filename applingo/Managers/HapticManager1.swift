import CoreHaptics
import SwiftUI

final class HapticManage1r: ObservableObject {
    static let shared = HapticManage1r()
    private var engine: CHHapticEngine?
    
    private init() {
        setupEngine()
    }
    
    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            Logger.warning("[HapticManager]: Initialization failed - \(error)")
        }
    }
    
    func playHapticPattern(intensity: Float, sharpness: Float, count: Int = 1) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        do {
            var events: [CHHapticEvent] = []
            
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
                    
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            Logger.warning("[HapticManager]: Failed repeat pattern - \(error)")
        }
    }
}
