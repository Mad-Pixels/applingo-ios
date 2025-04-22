import Foundation

struct ProfileModel: Codable, Equatable {
    var xpCurrent: Int64
    var level: Int64
    
    static let `default` = ProfileModel(xpCurrent: 0, level: 1)
    
    var xpNext: Int64 {
        return xpNeeded(for: level + 1)
    }
    
    var xpTotal: Int64 {
        var total = xpCurrent
        
        for lvl in 2..<max(2, level+1) {
            total += xpNeeded(for: lvl)
        }
        return total
    }
    
    private func xpNeeded(for level: Int64) -> Int64 {
        guard level > 1 else { return 0 }
        return 5000 + (1000 * (level - 2))
    }
    
    mutating func recalculateLevel() {
        while true {
            let required = xpNeeded(for: level + 1)
            if xpCurrent >= required {
                xpCurrent -= required
                level += 1
            } else {
                break
            }
        }
    }
}
