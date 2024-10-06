import SwiftUI

struct TabWordsView: View {
    var body: some View {
        VStack {
            Text("testWords")
                .font(.largeTitle)
                .padding()
            
            // Контент для вкладки "Words"
            Text("This is the Words View")
                .font(.title)
                .foregroundColor(.orange)
        }
    }
}


