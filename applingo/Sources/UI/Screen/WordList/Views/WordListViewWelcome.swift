import SwiftUI

/// A welcome view prompting the user to download a remote dictionary.
struct WordListViewWelcome: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    private let style: WordListStyle
    
    @State private var showRemoteDictionary = false

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
            Image("download_dictionary")
                .resizable()
                .scaledToFit()
                .frame(
                    width: style.iconSize,
                    height: style.iconSize
                )

            VStack {
                ButtonAction(
                    title: locale.screenButtonDownloadDictionaty,
                    action: { showRemoteDictionary = true },
                    style: .menu(themeManager.currentThemeStyle)
                )
                .padding()
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $showRemoteDictionary) {
            DictionaryRemoteList()
        }
    }
}
