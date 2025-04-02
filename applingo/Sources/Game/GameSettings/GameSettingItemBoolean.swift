import SwiftUI

class BooleanSettingItemBoolean: GameSetting, ObservableObject {
    var id: String
    var name: String
    
    @Published private(set) var value: Bool
    
    var onChange: ((Bool) -> Void)?
    
    init(id: String, name: String, defaultValue: Bool = false, onChange: ((Bool) -> Void)? = nil) {
        self.id = id
        self.name = name
        self.value = defaultValue
        self.onChange = onChange
    }
    
    func getValue() -> Any {
        return value
    }
    
    func setValue(_ value: Any) {
        guard let boolValue = value as? Bool else { return }
        self.value = boolValue
        onChange?(boolValue)
    }
    
    func binding() -> Binding<Bool> {
        return Binding(
            get: { self.value },
            set: {
                self.value = $0
                self.onChange?($0)
            }
        )
    }
}
