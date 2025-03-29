import SwiftUI

/// A view that displays the details of a remote dictionary item.
/// It provides a UI for viewing dictionary details and downloading the dictionary.
struct DictionaryRemoteDetails: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - State Objects
    @StateObject private var style: DictionaryRemoteDetailsStyle
    @StateObject private var locale = DictionaryRemoteDetailsLocale()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    // MARK: - Local State
    @State private var editedDictionary: ApiModelDictionaryItem
    @State private var isPressedTrailing = false
    @State private var dictionaryExists = false
    @State private var isDownloading = false
    
    // MARK: - Initializer
    /// Initializes a new instance of DictionaryRemoteDetails.
    /// - Parameters:
    ///   - dictionary: The remote dictionary item to display.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        dictionary: ApiModelDictionaryItem,
        style: DictionaryRemoteDetailsStyle? = nil
    ) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        _editedDictionary = State(initialValue: dictionary)
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(screen: .DictionaryRemoteDetails, title: locale.screenTitle) {
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
                        style: .close(ThemeManager.shared.currentThemeStyle)
                        
                    )
                }
            }
        }
        
        if dictionaryExists {
            Text(locale.screenSubtitleDictionaryExist)
                .padding(style.padding)
        } else if isDownloading {
            ProgressView(locale.screenButtonDownload)
                .progressViewStyle(CircularProgressViewStyle())
                .padding(style.padding)
        } else {
            ButtonAction(
                title: locale.screenButtonDownload,
                action: downloadDictionary,
                style: .action(ThemeManager.shared.currentThemeStyle)
            )
        }
    }
    
    // MARK: - Private Methods
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
