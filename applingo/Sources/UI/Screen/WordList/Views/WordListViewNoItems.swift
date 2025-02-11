import SwiftUI

struct WordListViewNoItems: View {
    
    // MARK: - Properties
    
    @ObservedObject var locale: WordListLocale
    let style: WordListStyle
    
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
