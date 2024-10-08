import SwiftUI

extension Binding where Value == String? {
    func unwrap(default value: String) -> Binding<String> {
        return Binding<String>(
            get: { self.wrappedValue ?? value },
            set: { self.wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
}
