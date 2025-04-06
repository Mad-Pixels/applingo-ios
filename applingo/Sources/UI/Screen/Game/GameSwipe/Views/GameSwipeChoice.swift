import SwiftUI

struct GameSwipeChoice: View {
    let dragOffset: CGSize
    let locale: GameSwipeLocale

    var body: some View {
        GeometryReader { geometry in
            HStack {
                if dragOffset.width < -20 {
                    Text(makeVertical(locale.screenCardWrong))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .opacity(textOpacity)
                        .animation(.easeInOut, value: dragOffset.width)
                        .glassBackground(cornerRadius: 12, opacity: 0.85)
                        .frame(maxWidth: 60, maxHeight: .infinity)
                        .zIndex(10)
                } else {
                    Spacer().frame(width: 60)
                }

                Spacer()

                if dragOffset.width > 20 {
                    Text(makeVertical(locale.screenCardRight))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .opacity(textOpacity)
                        .animation(.easeInOut, value: dragOffset.width)
                        .glassBackground(cornerRadius: 12, opacity: 0.85)
                        .frame(maxWidth: 60, maxHeight: .infinity)
                        .zIndex(10)
                } else {
                    Spacer().frame(width: 60)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }

    private var maxOffset: CGFloat {
        150
    }

    private var textOpacity: Double {
        let distance = abs(dragOffset.width)
        return min(0.5, Double(distance / maxOffset))
    }

    private func makeVertical(_ text: String) -> String {
        text.map { String($0) }.joined(separator: "\n")
    }
}
