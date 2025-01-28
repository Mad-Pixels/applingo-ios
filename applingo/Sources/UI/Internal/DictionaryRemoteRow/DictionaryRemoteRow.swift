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
                    Text(model.title)
                        .font(style.titleFont)
                        .foregroundColor(style.titleColor)
                    
                    if let pair = model.languagePair {
                        HStack(spacing: 4) {
                            FlagIcon(code: pair.from,
                                   style: .themed(ThemeManager.shared.currentThemeStyle))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11))
                                .foregroundColor(style.subtitleColor)
                            FlagIcon(code: pair.to,
                                   style: .themed(ThemeManager.shared.currentThemeStyle))
                        }
                    } else {
                        Text(model.subtitle)
                            .font(style.subtitleFont)
                            .foregroundColor(style.subtitleColor)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "graduationcap")
                            .font(.system(size: 11))
                            .foregroundColor(style.accentColor)
                        
                        Text(model.level)
                            .font(style.wordCountFont)
                            .foregroundColor(style.subtitleColor)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "book")
                            .font(.system(size: 11))
                            .foregroundColor(style.accentColor)
                        
                        Text(model.formattedWordCount)
                            .font(style.wordCountFont)
                            .foregroundColor(style.subtitleColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ButtonNav(
                    style: .download(ThemeManager.shared.currentThemeStyle, disabled: !true),
                    onTap: downloadDictionary,
                    isPressed: $isDownloadPressed
                )
                .disabled(!true)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
    private func downloadDictionary() {
        isDownloading = true
        Task {
            do {
                let fileURL = try await ApiManagerCache.shared.downloadDictionary(dictionary)
                let (downloadedDictionary, words) = try CSVManager.shared.parse(
                    url: fileURL,
                    dictionaryItem: DatabaseModelDictionary(
                        guid: dictionary.dictionary,
                        name: dictionary.name,
                        topic: dictionary.topic,
                        author: dictionary.author,
                        category: dictionary.category,
                        subcategory: dictionary.subcategory,
                        description: dictionary.description,
                        level: .undefined
                    )
                )
                try CSVManager.shared.saveToDatabase(dictionary: downloadedDictionary, words: words)
                try? FileManager.default.removeItem(at: fileURL)
                
                await MainActor.run {
                    isDownloading = false
                    NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
                }
            } catch {
                await MainActor.run {
                    isDownloading = false
                    ErrorManager.shared.process(
                        error,
                        screen: .DictionaryRemoteList,
                        metadata: [:]
                    )
                }
            }
        }
    }
}
