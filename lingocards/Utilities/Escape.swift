import Foundation

class Escape {
    static func text(_ text: String) -> String {
        text.components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: " -,.!()[]")).inverted)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
    static func word(_ text: String) -> String {
        text.components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: " -")).inverted)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
