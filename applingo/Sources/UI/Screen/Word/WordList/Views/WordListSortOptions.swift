import SwiftUI

internal struct WordListSortOptions: View {
    @Binding var selected: WordSortOption

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(WordSortOption.allCases) { option in
                    Button(action: {
                        selected = option
                    }) {
                        Image(systemName: option.iconName)
                            .font(.system(size: 18, weight: .medium))
                            .padding(8)
                            .background(selected == option ? Color.accentColor.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

