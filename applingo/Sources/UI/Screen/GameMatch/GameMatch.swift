import SwiftUI

/// Представление для игры «Match» с 16 кнопками (2 ряда по 8).
struct GameMatch: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MatchGameViewModel()
    /// Ожидается, что игра соответствует протоколу AbstractGame и реализует метод getItems(_:)
    @ObservedObject var game: Match

    var body: some View {
        VStack(spacing: 16) {
            Text("Счёт: \(viewModel.score)")
                .font(.title)
                .padding(.top)
            
            // Первый ряд: frontText
            HStack(spacing: 4) {
                ForEach(viewModel.frontItems, id: \.id) { word in
                    Button(action: {
                        viewModel.selectFront(word)
                    }) {
                        Text(word.frontText)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(viewModel.selectedFront?.id == word.id ? Color.blue.opacity(0.5) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            // Второй ряд: backText
            HStack(spacing: 4) {
                ForEach(viewModel.backItems, id: \.id) { word in
                    Button(action: {
                        viewModel.selectBack(word)
                    }) {
                        Text(word.backText)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(viewModel.selectedBack?.id == word.id ? Color.green.opacity(0.5) : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            if viewModel.frontItems.isEmpty && viewModel.backItems.isEmpty {
                Text("Поздравляем! Вы нашли все пары!")
                    .font(.headline)
                    .padding()
            }
            
            Button("Закрыть") {
                dismiss()
            }
            .padding(.top)
        }
        .padding()
        .onAppear {
            // Получаем 8 слов из кэша (метод getItems(_:) должен вернуть [DatabaseModelWord])
            if let words = game.getItems(8) as? [DatabaseModelWord] {
                viewModel.setupGame(with: words)
            }
        }
    }
}
