import Foundation

struct WordRowModel: Identifiable {
    let id: UUID = UUID()
    let frontText: String
    let backText: String
    var weight: Int
    
    init(frontText: String, backText: String, weight: Int = 500) {
        self.frontText = frontText
        self.backText = backText
        self.weight = max(0, min(1000, weight))
    }
}
