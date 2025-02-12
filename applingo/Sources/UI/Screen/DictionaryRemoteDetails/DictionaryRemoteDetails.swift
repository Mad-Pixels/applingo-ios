import SwiftUI

/// A view that displays the details of a remote dictionary item.
/// It provides a UI for viewing dictionary details and downloading the dictionary.
struct DictionaryRemoteDetails: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - State Objects
    @StateObject private var style: DictionaryRemoteDetailsStyle
    @StateObject private var locale = DictionaryRemoteDetailsLocale()
    
    // MARK: - Local State
    @State private var editedDictionary: ApiModelDictionaryItem
    @State private var isPressedTrailing = false
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
            .disabled(isDownloading)
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
