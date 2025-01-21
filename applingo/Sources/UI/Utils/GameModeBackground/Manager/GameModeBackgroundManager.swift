import SwiftUI

struct BackgroundShape: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
}

final class GameModeBackgroundManager: ObservableObject {
    static let shared = GameModeBackgroundManager()
    
    @Published private(set) var backgroundShapes: [BackgroundShape] = []
    
    private static var isFirstLaunchGenerated = false
    private let lock = NSLock()
    
    private let maxShapes = 20
    private let minSize: CGFloat = 100
    private let maxSize: CGFloat = 200
    private let minOpacity: Double = 0.02
    private let maxOpacity: Double = 0.06
    
    private init() {}
    
    func generateIfNeeded(for size: CGSize) {
        lock.lock()
        defer { lock.unlock() }
        
        guard !GameModeBackgroundManager.isFirstLaunchGenerated else { return }
        guard size.width > 0 && size.height > 0 else { return }
        generateBackground(for: size)
        GameModeBackgroundManager.isFirstLaunchGenerated = true
    }
    
    private func generateBackground(for size: CGSize) {
        var shapes: [BackgroundShape] = []
        
        for _ in 0..<maxShapes {
            shapes.append(BackgroundShape(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: minSize...maxSize),
                opacity: Double.random(in: minOpacity...maxOpacity)
            ))
        }
        
        self.backgroundShapes = shapes
    }
    
    func reset() {
        lock.lock()
        defer { lock.unlock() }
        backgroundShapes.removeAll()
        GameModeBackgroundManager.isFirstLaunchGenerated = false
    }
}
