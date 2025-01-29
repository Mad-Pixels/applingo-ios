import SwiftUI

struct DictionaryRemoteRow: View {
    let model: DictionaryRemoteRowModel
    let style: DictionaryRemoteRowStyle
    let dictionary: ApiModelDictionaryItem
    let onTap: () -> Void
    let onToggle: (Bool) -> Void
    
    @State private var isDownloadPressed = false
    @State private var isDownloading = false
    
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                VStack(alignment: .leading, spacing: style.spacing / 2) {
                    DictionaryRemoteRowViewLeft(model: model, style: style)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                DictionaryRemoteRowViewRight(model: model, style: style)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
