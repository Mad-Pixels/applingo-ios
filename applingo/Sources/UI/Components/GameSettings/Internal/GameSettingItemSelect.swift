import SwiftUI

class GameSettingItemSelect<V: Hashable>: GameSetting, ObservableObject {
    var id: String
    var name: String
    let options: [V]

    @Published private(set) var value: V
    var onChange: ((V) -> Void)?

    init(id: String, name: String, defaultValue: V, options: [V], onChange: ((V) -> Void)? = nil) {
        self.id = id
        self.name = name
        self.value = defaultValue
        self.options = options
        self.onChange = onChange
    }

    func getValue() -> Any {
        return value
    }

    func setValue(_ value: Any) {
        guard let typedValue = value as? V else { return }
        self.value = typedValue
        onChange?(typedValue)
    }

    func binding() -> Binding<V> {
        Binding(
            get: { self.value },
            set: {
                self.value = $0
                self.onChange?($0)
            }
        )
    }
}
