import Foundation

struct ProfileModel: Codable, Equatable {
    var xp: Int64
    private(set) var level: Int64

    static let `default` = ProfileModel(xp: 0, level: 1)

    private func xpNeeded(for level: Int64) -> Int64 {
        guard level > 1 else { return 0 }
        return 5000 * Int64(pow(2.0, Double(level - 2)))
    }

    mutating func recalculateLevel() {
        while true {
            let required = xpNeeded(for: level + 1)
            if xp >= required {
                xp -= required
                level += 1
            } else {
                break
            }
        }
    }
}
