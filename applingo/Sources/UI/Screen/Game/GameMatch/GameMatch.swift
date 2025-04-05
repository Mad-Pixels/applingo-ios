import SwiftUI

struct GameMatch: View {
    @StateObject private var viewModel: GameMatchViewModel
    @ObservedObject var game: Match
    
    @ObservedObject private var board: GameMatchBoard
    
    @State private var selectedLeftPosition: Int? = nil
    @State private var selectedRightPosition: Int? = nil

    init(game: Match) {
        let vm = GameMatchViewModel(game: game)
        _viewModel = StateObject(wrappedValue: vm)
        _board = ObservedObject(wrappedValue: vm.gameBoard)
        self.game = game
    }

    var body: some View {
        HStack(spacing: 20) {
            // Левая колонка (вопросы)
            VStack(spacing: 8) {
                ForEach(0..<board.columnLeft.count, id: \.self) { position in
                    let text = viewModel.gameBoard.text(position: position, isLeft: true)
                    if !text.isEmpty {
                        Text(text)
                            .padding()
                            .frame(height: 72)
                            .background(selectedLeftPosition == position ?
                                       Color.blue.opacity(0.5) :
                                       Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedLeftPosition = position
                                checkForMatch()
                            }
                    } else {
                        Color.clear
                            .frame(height: 72)
                    }
                }
            }
            .padding(.horizontal)

            // Разделитель
            Divider()

            // Правая колонка (ответы)
            VStack(spacing: 8) {
                ForEach(0..<board.columnRight.count, id: \.self) { position in
                    let text = viewModel.gameBoard.text(position: position, isLeft: false)
                    if !text.isEmpty {
                        Text(text)
                            .padding()
                            .frame(height: 72)
                            .background(selectedRightPosition == position ?
                                       Color.green.opacity(0.5) :
                                       Color.green.opacity(0.2))
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedRightPosition = position
                                checkForMatch()
                            }
                    } else {
                        Color.clear
                            .frame(height: 72)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            viewModel.generateCards()
        }
    }
    
    private func checkForMatch() {
        // Проверяем, выбраны ли карточки в обеих колонках
        if let left = selectedLeftPosition, let right = selectedRightPosition {
            
            viewModel.checkMatch(selectedLeft: left, selectedRight: right)
            selectedLeftPosition = nil
            selectedRightPosition = nil
        }
    }
}
