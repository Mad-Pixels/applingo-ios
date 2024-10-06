import SwiftUI

@main
struct LingocadrdApp: App {
    init() {
        Logger.initializeLogger()
    }
        
    var body: some Scene {
        WindowGroup { MainView() }
    }
}
