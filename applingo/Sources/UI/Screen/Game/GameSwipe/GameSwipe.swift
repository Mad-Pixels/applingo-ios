import SwiftUI

/// Представление для игры «Swipe» с карточкой, которую можно свайпать влево или вправо.
struct GameSwipe: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SwipeViewModel
    @ObservedObject var game: Swipe
    @ObservedObject private var cache: SwipeCache
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(game: Swipe) {
        self.game = game
        self._viewModel = StateObject(wrappedValue: SwipeViewModel(game: game))
        self.cache = game.cache
    }
    
    var body: some View {
        ZStack {
            themeManager.currentThemeStyle.backgroundPrimary.ignoresSafeArea()
            
            if viewModel.shouldShowEmptyView {
                Text("Нет доступных слов")
                    .font(.title)
                    .foregroundColor(themeManager.currentThemeStyle.textPrimary)
            } else if let card = viewModel.currentCard {
                cardView(for: card)
                    .offset(viewModel.dragOffset)
                    .rotationEffect(.degrees(viewModel.cardRotation))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                viewModel.handleDragGesture(value: value)
                            }
                            .onEnded { value in
                                viewModel.handleDragEnded(value: value)
                            }
                    )
            } else {
                ProgressView()
                    .scaleEffect(1.5)
                    .foregroundColor(themeManager.currentThemeStyle.accentPrimary)
            }
        }
        .onAppear {
            viewModel.generateCard()
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
    
    @ViewBuilder
    private func cardView(for card: SwipeModelCard) -> some View {
        VStack {
            // Индикаторы свайпа
            HStack {
                Text("❌ Не верно")
                    .foregroundColor(.red)
                    .opacity(viewModel.dragOffset.width < -20 ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.dragOffset.width)

                Spacer()

                Text("Верно ✅")
                    .foregroundColor(.green)
                    .opacity(viewModel.dragOffset.width > 20 ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.dragOffset.width)
            }
            .padding(.horizontal)

            // Карточка
            ZStack {
                // 🌈 Подложка с паттерном
                GameSwipeCardBackground(
                    cornerRadius: 20,
                    style: themeManager.currentThemeStyle
                )

                // 🎨 Основной фон
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.6))
                    .shadow(radius: 5)

                // 🖌️ Паттерн-граница
                GameCardSwipeBorder(
                    cornerRadius: 20,
                    style: themeManager.currentThemeStyle
                )

                // Контент
                VStack(spacing: 20) {
                    Text(card.frontText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentThemeStyle.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)

                    Divider()
                        .background(themeManager.currentThemeStyle.accentPrimary)
                        .padding(.horizontal, 30)

                    Text(card.backText)
                        .font(.title2)
                        .foregroundColor(themeManager.currentThemeStyle.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                }
                .padding()
            }
            .frame(width: 300, height: 400)
        }
    }
}

