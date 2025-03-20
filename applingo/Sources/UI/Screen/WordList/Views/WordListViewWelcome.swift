import SwiftUI

/// A welcome view prompting the user to download a remote dictionary.
struct WordListViewWelcome: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var locale: WordListLocale
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
                title: locale.screenButtonDownloadDictionary,
                subtitle: locale.screenButtonDownloadDictionaryDescription,
                iconType: .resource("dictionary_download"),
                action: { showRemoteDictionary = true },
                style: .add(themeManager.currentThemeStyle)
            )
            .padding(.horizontal, style.spacing + 8)
            .padding(.vertical, 8)
            
            ButtonMenu(
                title: locale.screenButtonImportDictionary,
                subtitle: locale.screenButtonImportDictionaryDescription,
                iconType: .resource("dictionary_import"),
                action: { showImportDictionary = true },
                style: .add(themeManager.currentThemeStyle)
            )
            .padding(.horizontal, style.spacing + 8)
            .padding(.bottom, 8)
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
