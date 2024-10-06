import SwiftUI

struct TabLearnView: View {
    
    var body: some View {
        VStack {
            Text("testLearn")
                .font(.largeTitle)
                .padding()
            
            // Контент для вкладки "Learn"
            Text("This is the Learn View")
                .font(.title)
                .foregroundColor(.blue)
            
            Button("Log Error") {
                            Logger.error("An error occurred!")  // Лог на уровне error
                        }
        }
    }
}
