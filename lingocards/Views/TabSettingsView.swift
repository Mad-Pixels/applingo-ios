import SwiftUI

struct TabSettingsView: View {
    var body: some View {
        VStack {
            Text("testSettings")
                .font(.largeTitle)
                .padding()
            
            // Контент для вкладки "Settings"
            Text("This is the Settings View")
                .font(.title)
                .foregroundColor(.red)
        }
    }
}
