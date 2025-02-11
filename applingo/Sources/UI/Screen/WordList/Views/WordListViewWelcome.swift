import SwiftUI

struct WordListViewWelcome: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showImportDictionary = false
    @State private var showRemoteDictionary = false

    var body: some View {
        VStack(spacing: 32) {
            Image("download_dictionary")
                .resizable()
                .scaledToFit()
                .frame(width: 215, height: 215)

            VStack(spacing: 16) {
                ButtonAction(
                    title: "Скачать словарь",
                    action: {
                        showRemoteDictionary = true
                    },
                    style: .menu(ThemeManager.shared.currentThemeStyle)
                )
                .padding()
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $showImportDictionary) {
            DictionaryImport(isPresented: $showImportDictionary)
        }
        .fullScreenCover(isPresented: $showRemoteDictionary) {
            DictionaryRemoteList(isPresented: $showRemoteDictionary)
        }
    }
}
