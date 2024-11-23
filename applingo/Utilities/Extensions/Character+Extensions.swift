import SwiftUI

extension CharacterSet {
    static let nonBaseCharacters: CharacterSet = {
        var set = CharacterSet.controlCharacters
        set.formUnion(.illegalCharacters)
        set.formUnion(CharacterSet(charactersIn: "\u{0300}"..."\u{036F}"))
        return set
    }()
}

extension Character {
    func validForDisplay() -> Character? {
        let string = String(self)
        
        guard !string.isEmpty else { return nil }
        for scalar in string.unicodeScalars {
            if CharacterSet.whitespacesAndNewlines.contains(scalar) || CharacterSet.controlCharacters.contains(scalar) {
                return nil
            }
        }
        guard string != "�" else { return nil }
        
        let scalars = string.unicodeScalars
        guard scalars.allSatisfy({ !CharacterSet.nonBaseCharacters.contains($0) }) else {
            return nil
        }
        return self
    }
}
