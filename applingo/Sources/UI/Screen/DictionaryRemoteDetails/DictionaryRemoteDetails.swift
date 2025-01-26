import SwiftUI

struct DictionaryRemoteDetails: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryRemoteDetailsStyle
    @StateObject private var locale = DictionaryRemoteDetailsLocale()

    @State private var editedDictionary: DatabaseModelDictionary
    @State private var isPressedTrailing = false
    @State private var isDownloading = false
    @Binding var isPresented: Bool

    init(
        dictionary: DatabaseModelDictionary,
        isPresented: Binding<Bool>,
        style: DictionaryRemoteDetailsStyle? = nil
    ) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
    }

    var body: some View {
        BaseScreen(
            screen: .dictionariesRemoteDetail,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryRemoteDetailsViewMain(
                        dictionary: editedDictionary,
                        locale: locale,
                        style: style
                    )

                    DictionaryRemoteDetailsViewCategory(
                        dictionary: editedDictionary,
                        locale: locale,
                        style: style
                    )

                    DictionaryRemoteDetailsViewAdditional(
                        dictionary: editedDictionary,
                        locale: locale,
                        style: style
                    )
                }
                .padding(style.padding)
            }
            .disabled(isDownloading)
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .close(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        isPressed: $isPressedTrailing
                    )
                }
            }
        }

        if isDownloading {
            ProgressView(locale.downloadingTitle)
                .progressViewStyle(CircularProgressViewStyle())
                .padding(style.padding)
        } else {
            ButtonAction(
                title: locale.downloadTitle,
                action: downloadDictionary,
                style: .action(ThemeManager.shared.currentThemeStyle)
            )
        }
    }

    private func downloadDictionary() {
        isDownloading = true
        Task {
            do {
                let fileURL = try await ApiManagerCache.shared.downloadDictionary(editedDictionary)
                let (dictionary, words) = try CSVManager.shared.parse(
                    url: fileURL,
                    dictionaryItem: editedDictionary
                )
                try CSVManager.shared.saveToDatabase(dictionary: dictionary, words: words)
                try? FileManager.default.removeItem(at: fileURL)

                await MainActor.run {
                    isDownloading = false
                    NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                await MainActor.run {
                    isDownloading = false
                    ErrorManager.shared.process(
                        error,
                        screen: .dictionariesRemoteDetail,
                        metadata: [:]
                    )
                }
            }
        }
    }
}
