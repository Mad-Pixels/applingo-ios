import SwiftUI

internal struct WordListSortOptions: View {
    let style: WordListStyle
    @Binding var selected: WordSortOption

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                ForEach(WordSortOption.allCases) { option in
                    Button(action: {
                        selected = option
                    }) {
                        Image(systemName: option.iconName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(selected == option ? style.accentColor : style.accentColor)
                            .padding(4)
                            .background(
                                Circle()
                                    .fill(selected == option ? style.accentColor.opacity(0.2) : Color.clear)
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}
