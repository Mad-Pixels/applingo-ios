import SwiftUI

struct LocalizedText: View {
    @ObservedObject private var localeManager = LocaleManager.shared
    let key: String
    let arguments: [CVarArg]
    
    init(_ key: String, _ arguments: CVarArg...) {
        self.key = key
        self.arguments = arguments
    }
    
    var body: some View {
        Text(localeManager.localizedString(for: key, arguments: arguments))
            .id(localeManager.viewId)
    }
}

struct LocalizedString {
    let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var localized: String {
        LocaleManager.shared.localizedString(for: key).capitalizedFirstLetter
    }
}
