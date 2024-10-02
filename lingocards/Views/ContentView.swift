import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: GreetingViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: GreetingViewModel())
    }
    
    var body: some View {
        Text(viewModel.greeting.message)
            .padding()
            .onAppear {
                viewModel.logGreeting(logger: appState.logger)
            }
    }
}

