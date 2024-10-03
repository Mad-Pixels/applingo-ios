import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
        viewModel.fetchDownload()
    }
    
    var body: some View {
        VStack {
            Text(viewModel.message)
                .padding()
            
            List(viewModel.dictionaryItems) { item in
                Text(item.name)
            }
            
            Button("Refresh") {
                viewModel.fetchDictionary()
            }
        }
    }
}

