import SwiftUI

struct TabDictionariesView: View {
    @EnvironmentObject var tabManager: TabManager
    
    var body: some View {
        VStack {
            Text("testDictionaries")
                .font(.largeTitle)
                .padding()
            
            Text("This is the Dictionaries View")
                .font(.title)
                .foregroundColor(.green)
        }
        .onAppear {
            tabManager.setActiveTab(.dictionaries)
        }
        .onChange(of: tabManager.activeTab) { oldTab, newTab in
            if newTab != .dictionaries {
                tabManager.deactivateTab(.dictionaries)
            }
        }
    }
}
