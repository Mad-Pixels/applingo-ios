import SwiftUI

extension String {
    var capitalizedFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var trimmedTrailingWhitespace: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
