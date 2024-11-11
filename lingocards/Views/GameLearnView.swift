import SwiftUI

struct GameLearnView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameLearnContent()
        }
    }
}

struct GameLearnContent: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                Text("Cache Status:")
                    .font(.headline)
                
                Text("Total items: \(viewModel.cache.count)")
                    .font(.subheadline)
                    
                if viewModel.isLoadingCache {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.cache) { word in
                        WordCacheItemView(word: word)
                    }
                }
                .padding()
            }
        }
    }
}

struct WordCacheItemView: View {
    let word: WordItemModel
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(word.frontText)
                    .font(.headline)
                Spacer()
                Text("Weight: \(word.weight)")
                    .font(.caption)
            }
            
            Text(word.backText)
                .font(.subheadline)
                .foregroundColor(theme.secondaryTextColor)
            
            Text("Dictionary: \(word.tableName)")
                .font(.caption)
                .foregroundColor(theme.secondaryTextColor)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.backgroundBlockColor)
        }
        .foregroundColor(theme.baseTextColor)
    }
}
