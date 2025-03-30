import SwiftUI

struct DictionaryRemoteDetails: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var style: DictionaryRemoteDetailsStyle
    @StateObject private var locale = DictionaryRemoteDetailsLocale()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    @State private var editedDictionary: ApiModelDictionaryItem
    @State private var isPressedTrailing = false
    @State private var dictionaryExists = false
    @State private var isDownloading = false
    
    /// Initializes the DictionaryRemoteDetails.
    /// - Parameters:
    ///   - dictionary: The remote dictionary item to display.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        dictionary: ApiModelDictionaryItem,
        style: DictionaryRemoteDetailsStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
        _editedDictionary = State(initialValue: dictionary)
    }
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryRemoteDetails,
            title: locale.screenTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryRemoteDetailsViewMain(
                        style: style,
                        locale: locale,
                        dictionary: editedDictionary
                    )
                    
                    DictionaryRemoteDetailsViewCategory(
                        style: style,
                        locale: locale,
                        dictionary: editedDictionary
                    )
                    
                    DictionaryRemoteDetailsViewAdditional(
                        style: style,
                        locale: locale,
                        dictionary: editedDictionary
                    )
                }
                .padding(style.padding)
            }
            .onAppear() {
                dictionaryAction.setScreen(.DictionaryRemoteDetails)
                dictionaryAction.exists(guid: editedDictionary.id) { result in
                    if case .success(let exists) = result {
                        dictionaryExists = exists
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        isPressed: $isPressedTrailing,
                        onTap: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        style: .close(themeManager.currentThemeStyle)
                    )
                }
            }
        }
        
        if dictionaryExists {
            DynamicText(
                model: DynamicTextModel(text: locale.screenSubtitleDictionaryExist),
                style: .textGame(
                    themeManager.currentThemeStyle,
                    alignment: .center,
                    lineLimit: 1
                )
            )
            .padding(style.padding)
        } else if isDownloading {
            ProgressView(locale.screenButtonDownload)
                .progressViewStyle(CircularProgressViewStyle())
                .padding(style.padding)
        } else {
            ButtonAction(
                title: locale.screenButtonDownload,
                action: downloadDictionary,
                style: .action(themeManager.currentThemeStyle)
            )
        }
    }
    
    /// Initiates the download of the dictionary.
    private func downloadDictionary() {
        isDownloading = true
        Task {
            do {
                try await DictionaryDownload.shared.download(
                    dictionary: editedDictionary,
                    screen: .DictionaryRemoteDetails
                )
                await MainActor.run {
                    isDownloading = false
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {}
        }
    }
}
