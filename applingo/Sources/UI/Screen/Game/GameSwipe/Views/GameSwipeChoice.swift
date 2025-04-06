import SwiftUI

struct GameSwipeChoice: View {
    let dragOffset: CGSize
    let locale: GameSwipeLocale

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !directionText.isEmpty {
                    Text(directionText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(directionColor)
                        .opacity(textOpacity)
                        .animation(.easeInOut, value: dragOffset.width)
                        .frame(maxWidth: .infinity)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 2 - 250)
                }
            }
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

    private var directionText: String {
        if dragOffset.width < -20 {
            return locale.screenCardWrong
        } else if dragOffset.width > 20 {
            return locale.screenCardRight
        } else {
            return ""
        }
    }

    private var directionColor: Color {
        dragOffset.width < 0 ? .red : .green
    }
}
