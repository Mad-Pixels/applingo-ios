import SwiftUI

/// Manages the generation and storage of game mode background shapes.
final class BackgroundGameModeManager: ObservableObject {
    static let shared = BackgroundGameModeManager()
    
    /// Array of generated background shapes.
    @Published private(set) var backgroundShapes: [BackgroundGameModeModelShape] = []
    
    private static var isFirstLaunchGenerated = false
    private let minOpacity: Double = 0.02
    private let maxOpacity: Double = 0.06
    private let minSize: CGFloat = 100
    private let maxSize: CGFloat = 200
    private let padding: CGFloat = 3
    private let lock = NSLock()
    private let maxShapes = 20
    
    // MARK: - Public Methods

    /// Generates background shapes for the given size if not already generated.
    /// - Parameters:
    ///   - size: The available screen size.
    ///   - colors: Array of colors to choose from.
    func generateIfNeeded(for size: CGSize, using colors: [Color]) {
        lock.lock()
        defer { lock.unlock() }
        
        guard !BackgroundGameModeManager.isFirstLaunchGenerated else { return }
        guard size.width > 0 && size.height > 0 else { return }
        generateBackground(for: size, using: colors)
        BackgroundGameModeManager.isFirstLaunchGenerated = true
    }
    
    /// Resets the generated background shapes.
    func reset() {
        lock.lock()
        defer { lock.unlock() }
        backgroundShapes.removeAll()
        BackgroundGameModeManager.isFirstLaunchGenerated = false
    }
    
    // MARK: - Private Methods

    /// Generates background shapes based on the available size.
    /// - Parameters:
    ///   - size: The available screen size.
    ///   - colors: Array of colors to choose from.
    private func generateBackground(for size: CGSize, using colors: [Color]) {
        var shapes: [BackgroundGameModeModelShape] = []
        var occupiedRects: [CGRect] = []
        
        for _ in 0..<maxShapes {
            let shapeSize = CGFloat.random(in: minSize...maxSize)
            let x = CGFloat.random(in: padding...(size.width - padding))
            let y = CGFloat.random(in: padding...(size.height - padding))
            
            let newRect = CGRect(
                x: x - shapeSize / 2,
                y: y - shapeSize / 2,
                width: shapeSize,
                height: shapeSize
            ).insetBy(dx: -padding / 2, dy: -padding / 2)
            
            if !occupiedRects.contains(where: { $0.intersects(newRect) }) {
                occupiedRects.append(newRect)
                
                shapes.append(BackgroundGameModeModelShape(
                    id: UUID(),
                    position: CGPoint(x: x, y: y),
                    opacity: Double.random(in: minOpacity...maxOpacity),
                    size: shapeSize,
                    color: colors.randomElement() ?? .blue
                ))
            }
        }
        self.backgroundShapes = shapes
    }
}
