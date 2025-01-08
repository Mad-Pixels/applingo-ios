import SwiftUI

struct CompGameEmptyView: View {
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(spacing: 20) {
            Image(systemName: "text.book.closed.fill")
                .font(.system(size: 60))
                .foregroundColor(theme.accentPrimary)
            
            Text(LanguageManager.shared.localizedString(for: "NotEnoughWords")) 
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
            
            Text(LanguageManager.shared.localizedString(for: "AddWordsOrActivateDictionaries"))
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(theme.textSecondary)
        }
        .padding()
    }
}
