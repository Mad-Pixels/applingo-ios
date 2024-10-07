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
                Logger.error("Ошибка подключения к серверу", type: .network, additionalInfo: ["URL": "https://example.com", "Timeout": "30"])
  // Лог на уровне error
                        }
        }
    }
}
