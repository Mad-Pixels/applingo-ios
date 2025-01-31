import SwiftUI

/// A view that displays the details of a remote dictionary item.
/// It provides a UI for viewing dictionary details and downloading the dictionary.
struct DictionaryRemoteDetails: View {
    
    // MARK: - Environment and State Properties
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryRemoteDetailsStyle
    @StateObject private var locale = DictionaryRemoteDetailsLocale()
    
    /// The edited dictionary model.
    @State private var editedDictionary: ApiModelDictionaryItem
    @State private var isPressedTrailing = false
    @State private var isDownloading = false
    
    /// Binding to control the presentation state.
    @Binding var isPresented: Bool
    
    // MARK: - Initializer
    
    /// Initializes a new instance of DictionaryRemoteDetails.
    /// - Parameters:
    ///   - dictionary: The remote dictionary item to display.
    ///   - isPresented: Binding to the presentation state.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        dictionary: ApiModelDictionaryItem,
        isPresented: Binding<Bool>,
        style: DictionaryRemoteDetailsStyle? = nil
    ) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .DictionaryRemoteDetails, title: locale.navigationTitle) {
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
        // Show a progress view if downloading; otherwise, display the download button.
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
    
    // MARK: - Private Methods
    
    /// Initiates the download of the dictionary.
    private func downloadDictionary() {
        isDownloading = true
        Task {
            do {
                try await DictionaryDownload.shared.download(dictionary: editedDictionary)
                await MainActor.run {
                    isDownloading = false
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                await MainActor.run {
                    isDownloading = false
                    ErrorManager.shared.process(
                        error,
                        screen: .DictionaryRemoteDetails,
                        metadata: [:]
                    )
                }
            }
        }
    }
}
