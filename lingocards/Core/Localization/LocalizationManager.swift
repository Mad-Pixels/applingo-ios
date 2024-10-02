import Foundation

protocol LocalizationManagerProtocol {
    func setLanguage(_ language: String)
    func localizedString(for key: String) -> String
}

class LocalizationManager: LocalizationManagerProtocol {
    private var bundle: Bundle?
    
    func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return
        }
        self.bundle = bundle
    }
    
    func localizedString(for key: String) -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
