import SwiftUI

struct DictionaryRemoteList: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                    .font(.largeTitle)
                    .padding()

                Button(action: {
                    // Закрыть полноэкранное представление
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.title2)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Remote Dictionaries")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea()
    }
}
