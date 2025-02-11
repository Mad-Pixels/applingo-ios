import SwiftUI

struct DictionaryLocalListViewNoItems: View {
    
    // MARK: - Properties
    
    @ObservedObject var locale: DictionaryLocalListLocale
    let style: DictionaryLocalListStyle
    
    // MARK: - Body
    
    var body: some View {
        VStack() {
            Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "warning_dark" : "warning_light")
                .resizable()
                .scaledToFit()
                .frame(width: 215, height: 215)
            Text(locale.screenNoWords).font(style.titleFont)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
