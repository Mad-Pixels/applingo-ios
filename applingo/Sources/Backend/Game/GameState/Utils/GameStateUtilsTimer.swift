import Foundation

/// An observable timer utility class designed to manage and update the remaining time in a game state.
///
/// `GameStateUtilsTimer` uses a `Timer` to provide smooth, periodic updates of the remaining time.
/// It exposes the remaining time through a published property so that SwiftUI views can reactively update.
/// When the timer reaches zero, the timer stops and an optional closure (`onTimeUp`) is executed.
final class GameStateUtilsTimer: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var timeLeft: TimeInterval
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var endTime: Date?
    
    var onTimeUp: (() -> Void)?
    
    // MARK: - Initializer
    /// Initializes a new timer with the specified duration.
    ///
    /// - Parameter duration: The duration (in seconds) for which the timer should run.
    init(duration: TimeInterval) {
        self.timeLeft = duration
    }
    
    // MARK: - Methods
    /// Starts the timer.
    ///
    /// This method calculates the end time based on the current `timeLeft`, then schedules a Timer to update
    /// the `timeLeft` property at regular intervals (every 0.1 seconds) for a smooth animation effect.
    /// When the current time exceeds the end time, the timer stops and the `onTimeUp` closure is executed.
    final func start() {
        endTime = Date().addingTimeInterval(timeLeft)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self,
                  let endTime = self.endTime else { return }
            
            let now = Date()
            if now >= endTime {
                self.timeLeft = 0
                self.stop()
                self.onTimeUp?()
            } else {
                self.timeLeft = endTime.timeIntervalSince(now)
            }
        }
        timer?.tolerance = 0.1
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// Stops the timer and clears the related properties.
    ///
    /// This method invalidates the current timer, ensuring it stops running, and resets the timer and endTime.
    final func stop() {
        timer?.invalidate()
        
        endTime = nil
        timer = nil
    }
}
