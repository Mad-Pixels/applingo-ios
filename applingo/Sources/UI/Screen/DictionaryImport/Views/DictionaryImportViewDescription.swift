import SwiftUI

struct DictionaryImportViewDescription: View {
    let locale: DictionaryImportLocale
    let style: DictionaryImportStyle
   
   var body: some View {
       VStack(spacing: 16) {
           HStack(spacing: 16) {
               cardView(title: locale.tableColumnA)
               cardView(title: locale.tableColumnB)
           }
           
           HStack(spacing: 16) {
               cardView(title: locale.tableColumnC)
               cardView(title: locale.tableColumnD)
           }
       }
   }
   
   private func cardView(title: String) -> some View {
       SectionBody {
           VStack(alignment: .leading, spacing: style.sectionSpacing) {
               SectionHeader(
                   title: title.uppercased(),
                   style: .heading(ThemeManager.shared.currentThemeStyle)
               )
           }
       }
       .frame(maxWidth: .infinity)
   }
}
