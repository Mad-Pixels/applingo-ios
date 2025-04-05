import SwiftUI

struct GameMatch: View {
    @StateObject private var viewModel: MatchViewModel
    @ObservedObject var game: Match

    @ObservedObject private var board: GameMatchBoard

    @State private var selectedLeftPosition: Int? = nil
    @State private var selectedRightPosition: Int? = nil

    init(game: Match) {
        let vm = MatchViewModel(game: game)
        
        _viewModel = StateObject(wrappedValue: vm)
        _board = ObservedObject(wrappedValue: vm.gameBoard)
        self.game = game
    }

    var body: some View {
        HStack(spacing: 20) {
            // Левая колонка (вопросы)
            VStack(spacing: 8) {
                ForEach(0..<board.columnLeft.count, id: \.self) { position in
                    let text = board.text(position: position, isLeft: true)
                    if !text.isEmpty {
                        GameMatchButton(
                            text: text,
                            action: {
                                selectedLeftPosition = position
                                checkForMatch()
                            },
                            isSelected: selectedLeftPosition == position,
                            isMatched: false
                        )
                        .frame(height: 72)
                    } else {
                        Color.clear.frame(height: 72)
                    }
                }
            }
            .padding(.horizontal)

            // Разделитель
            GameMatchViewSeparator()

            // Правая колонка (ответы)
            VStack(spacing: 8) {
                ForEach(0..<board.columnRight.count, id: \.self) { position in
                    let text = board.text(position: position, isLeft: false)
                    if !text.isEmpty {
                        GameMatchButton(
                            text: text,
                            action: {
                                selectedRightPosition = position
                                checkForMatch()
                            },
                            isSelected: selectedRightPosition == position,
                            isMatched: false
                        )
                        .frame(height: 72)
                    } else {
                        Color.clear.frame(height: 72)
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
        if let left = selectedLeftPosition, let right = selectedRightPosition {
            viewModel.checkMatch(selectedLeft: left, selectedRight: right)
            selectedLeftPosition = nil
            selectedRightPosition = nil
        }
    }
}
