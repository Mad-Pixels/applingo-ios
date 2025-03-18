import SwiftUI

/// A welcome view prompting the user to download a remote dictionary.
struct WordListViewWelcome: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    private let style: WordListStyle
    
    @State private var showRemoteDictionary = false
    @State private var showImportDictionary = false

    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - locale: `WordListLocale` object that provides localized strings.
    init(style: WordListStyle, locale: WordListLocale) {
        self.locale = locale
        self.style = style
    }

    // MARK: - Body
    var body: some View {
        VStack {
            ButtonMenu(
                title: locale.screenButtonDownloadDictionaty,
                action: { showRemoteDictionary = true },
                style: .themed(themeManager.currentThemeStyle)
            )
            .padding()
            
            ButtonMenu(
                title: locale.screenButtonImportDictionaty,
                action: { showImportDictionary = true },
                style: .themed(themeManager.currentThemeStyle)
            )
            .padding()
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $showRemoteDictionary) {
            DictionaryRemoteList()
        }
        .fullScreenCover(isPresented: $showImportDictionary) {
            DictionaryImport(isPresented: $showImportDictionary)
        }
    }
}
