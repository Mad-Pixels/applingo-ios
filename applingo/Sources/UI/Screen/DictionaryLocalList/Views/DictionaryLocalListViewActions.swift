import SwiftUI

struct DictionaryLocalListViewActions: View {
   let onImport: () -> Void
   let onDownload: () -> Void
   private let locale: DictionaryLocalListLocale
   
   init(
       locale: DictionaryLocalListLocale,
       onImport: @escaping () -> Void,
       onDownload: @escaping () -> Void
   ) {
       self.locale = locale
       self.onImport = onImport
       self.onDownload = onDownload
   }
   
   var body: some View {
       ButtonFloatingMultiple(
           items: [
            ButtonFloatingModelIconAction(
                   icon: "tray.and.arrow.down",
                   action: onImport
               ),
            ButtonFloatingModelIconAction(
                   icon: "arrow.down.circle",
                   action: onDownload
               )
           ]
       )
   }
}
