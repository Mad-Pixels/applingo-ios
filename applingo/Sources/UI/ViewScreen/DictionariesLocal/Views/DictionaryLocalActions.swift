import SwiftUI

struct DictionaryLocalActions: View {
   let onImport: () -> Void
   let onDownload: () -> Void
   private let locale: ScreenDictionariesLocalLocale
   
   init(
       locale: ScreenDictionariesLocalLocale,
       onImport: @escaping () -> Void,
       onDownload: @escaping () -> Void
   ) {
       self.locale = locale
       self.onImport = onImport
       self.onDownload = onDownload
   }
   
   var body: some View {
       FloatingButtonMultiple(
           items: [
               IconAction(
                   icon: "tray.and.arrow.down",
                   action: onImport
               ),
               IconAction(
                   icon: "arrow.down.circle",
                   action: onDownload
               )
           ]
       )
   }
}
