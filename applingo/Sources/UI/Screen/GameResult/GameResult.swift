import SwiftUI

struct GameResult: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
//    private var resultText: String {
//        if let reason = gameState.endReason {
//            switch reason {
//            case .timeUp:
//                return "Время вышло!"
//            case .noLives:
//                return "Игра окончена!"
//            default:
//                return "Конец игры"
//            }
//        }
//        return "Конец игры"
//    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("resultText")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    gameState.isGameOver = true
                }
            }) {
                Text("Закрыть")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}


import SwiftUI

/// A custom view modifier that presents a centered modal with a dimmed background.
struct CenteredModal<ModalContent: View>: ViewModifier {
    /// Controls the visibility of the modal.
    let isPresented: Bool
    /// The content of the modal.
    let modalContent: ModalContent

    func body(content: Content) -> some View {
        ZStack {
            // Underlying content
            content

            if isPresented {
                // Dimmed background
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isPresented)

                // Centered modal view
                modalContent
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .transition(.scale)
                    .animation(.spring(), value: isPresented)
            }
        }
    }
}

extension View {
    /// A helper function to apply the CenteredModal view modifier.
    func centeredModal<ModalContent: View>(
        isPresented: Bool,
        @ViewBuilder modalContent: () -> ModalContent
    ) -> some View {
        self.modifier(CenteredModal(isPresented: isPresented, modalContent: modalContent()))
    }
}

