import SwiftUI

struct DictionaryListLocalViewActions: View {
   let onImport: () -> Void
   let onDownload: () -> Void
   private let locale: DictionaryListLocalLocale
   
   init(
       locale: DictionaryListLocalLocale,
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
            ButtonFloatingIconAction(
                   icon: "tray.and.arrow.down",
                   action: onImport
               ),
            ButtonFloatingIconAction(
                   icon: "arrow.down.circle",
                   action: onDownload
               )
           ]
       )
   }
}
