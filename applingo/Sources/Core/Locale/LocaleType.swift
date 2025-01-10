import Foundation

enum LocaleType: String, CaseIterable {
    case english = "en"
    case russian = "ru"
    
    static func fromString(_ string: String) -> LocaleType {
        return LocaleType(rawValue: string) ?? .english
    }
    
    var asString: String {
        return self.rawValue
    }
    
    var displayName: String {
        Locale(identifier: self.rawValue)
            .localizedString(forIdentifier: self.rawValue)?.lowercased() ?? self.rawValue
    }
}
