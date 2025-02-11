import SwiftUI

/// A welcome view prompting the user to download a remote dictionary.
struct WordListViewWelcome: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showRemoteDictionary = false
    private let locale: WordListLocale
    private let style: WordListStyle

    // MARK: - Initializer
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
            DictionaryRemoteList(isPresented: $showRemoteDictionary)
        }
    }
}
