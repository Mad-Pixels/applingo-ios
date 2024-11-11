import SwiftUI

struct CompGameStateView: View {
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(spacing: 20) {
            Image(systemName: "text.book.closed.fill")
                .font(.system(size: 60))
                .foregroundColor(theme.accentColor)
            
            Text(LanguageManager.shared.localizedString(for: "NotEnoughWords"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.baseTextColor)
            
            Text(LanguageManager.shared.localizedString(for: "AddWordsOrActivateDictionaries"))
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(theme.secondaryTextColor)
        }
        .padding()
    }
}
