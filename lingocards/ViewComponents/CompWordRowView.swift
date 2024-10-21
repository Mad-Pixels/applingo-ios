import SwiftUI

struct CompWordRowView: View {
    let word: WordItem
    let onTap: () -> Void
    let theme: ThemeStyle

    var body: some View {
        HStack {
            // Первая колонка: выравнивание влево
            Text(word.frontText)
                .font(.headline)
                .foregroundColor(theme.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Вторая колонка: выравнивание по центру
            Image(systemName: "arrow.left.and.right.circle.fill")
                .foregroundColor(theme.primaryButtonColor)
                .frame(width: 24, height: 24)
                .frame(maxWidth: .infinity, alignment: .center)

            // Третья колонка: выравнивание вправо
            Text(word.backText)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

