import SwiftUI

struct ScreenDictionaryDetail: View {
   @Environment(\.presentationMode) private var presentationMode
   @StateObject private var style: ScreenDictionaryDetailStyle
   @StateObject private var locale = ScreenDictionaryDetailLocale()
   
   @State private var editedDictionary: DictionaryItemModel
   @State private var isDownloading = false
   @Binding var isPresented: Bool
   
   init(
       dictionary: DictionaryItemModel,
       isPresented: Binding<Bool>,
       style: ScreenDictionaryDetailStyle? = nil
   ) {
       let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
       _style = StateObject(wrappedValue: initialStyle)
       _editedDictionary = State(initialValue: dictionary)
       _isPresented = isPresented
   }
   
   var body: some View {
       BaseViewScreen(screen: .dictionariesRemoteDetail) {
           VStack {
               Form {
                   DictionaryDetailMainSection(
                       dictionary: editedDictionary,
                       locale: locale
                   )
                   
                   DictionaryDetailCategorySection(
                       dictionary: editedDictionary,
                       locale: locale
                   )
                   
                   DictionaryDetailAdditionalSection(
                       dictionary: editedDictionary,
                       locale: locale
                   )
               }
               
               if isDownloading {
                   ProgressView(locale.downloadingTitle)
                       .progressViewStyle(CircularProgressViewStyle())
                       .padding(style.padding)
               } else {
                   ButtonAction(
                       title: locale.downloadTitle,
                       type: .action,
                       action: downloadDictionary
                   )
                   .padding(style.padding)
               }
           }
           .disabled(isDownloading)
           .navigationTitle(locale.navigationTitle)
           .navigationBarTitleDisplayMode(.inline)
           .navigationBarItems(
               trailing: Button(locale.closeTitle) {
                   presentationMode.wrappedValue.dismiss()
               }
           )
       }
   }
   
   private func downloadDictionary() {
       isDownloading = true
       
       Task {
           do {
               let fileURL = try await RepositoryCache.shared.downloadDictionary(editedDictionary)
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
                       screen: .dictionariesRemoteDetail
                   )
               }
           }
       }
   }
}
