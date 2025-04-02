import SwiftUI

protocol GameSetting: Identifiable {
    var id: String { get }
    
    var name: String { get }
    
    func getValue() -> Any
    
    func setValue(_ value: Any)
}
