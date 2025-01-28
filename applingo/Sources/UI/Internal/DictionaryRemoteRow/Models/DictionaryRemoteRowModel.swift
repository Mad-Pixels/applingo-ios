import SwiftUI

struct DictionaryRemoteRowModel {
    let subcategory: String
    let description: String
    let category: String
    let title: String
    let level: String
    let topic: String
    let words: Int
    
    var languagePair: (from: String, to: String)? {
        let components = subcategory.split(separator: "-")
        guard components.count == 2,
              components[0].count == 2,
              components[1].count == 2
        else {
            return nil
        }
        return (from: String(components[0]).lowercased(),
                to: String(components[1]).lowercased())
    }
    
    var subtitle: String {
        if languagePair != nil {
            return ""
        } else {
            return "[\(category)] \(subcategory)"
        }
    }
    
    var formattedWordCount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "\(formatter.string(from: NSNumber(value: words)) ?? String(words)) words"
    }
}
