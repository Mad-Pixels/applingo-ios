import Foundation

final class GameStateUtilsTimer: ObservableObject {
    @Published private(set) var timeLeft: TimeInterval
    
    private var timer: Timer?
    private var endTime: Date?
    
    var onTimeUp: (() -> Void)?
    
    /// Initializes the GameStateUtilsTimer.
    /// - Parameter duration: The duration (in seconds) for which the timer should run.
    init(duration: TimeInterval) {
        self.timeLeft = duration
    }
    
    /// Starts the timer.
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
    final func stop() {
        timer?.invalidate()
        
        endTime = nil
        timer = nil
    }
}
