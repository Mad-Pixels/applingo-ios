import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    
    init(apiManager: APIManagerProtocol) {
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager))
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

