import SwiftUI

struct FloatingButtonSingle: View {
    let icon: String
    let action: () -> Void
    let style: FloatingButtonStyle

    var body: some View {
        ZStack {
            Button(action: action) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .frame(
                        width: style.mainButtonSize.width,
                        height: style.mainButtonSize.height
                    )
                    .background(style.mainButtonColor)
                    .cornerRadius(style.cornerRadius)
                    .shadow(
                        color: style.shadowColor,
                        radius: style.shadowRadius
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
    }
}
