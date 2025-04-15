import Foundation
import MultipeerConnectivity

enum NearbyAvailability {
    static var isAvailable: Bool {
        // На iOS MultipeerConnectivity доступна с iOS 13+
        // Можно также расширить проверку на конкретные ограничения
        return true
    }
}
