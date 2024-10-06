import SwiftUI

struct TabDictionariesView: View {
    var body: some View {
        VStack {
            Text("testDictionaries")
                .font(.largeTitle)
                .padding()
            
            // Контент для вкладки "Dictionaries"
            Text("This is the Dictionaries View")
                .font(.title)
                .foregroundColor(.green)
        }
    }
}

