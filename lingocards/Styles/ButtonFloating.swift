import SwiftUI

struct ButtonFloating: View {
    var action: () -> Void
    var imageName: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 10)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }
}
