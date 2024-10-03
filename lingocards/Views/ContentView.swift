import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    @EnvironmentObject private var appState: AppState
    
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.message)
                
                Button("Fetch Dictionary") {
                    viewModel.fetchDictionary()
                }
                
                Button("Fetch Download") {
                    viewModel.fetchDownload()
                }
                
                List(viewModel.dictionaryItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.description).font(.subheadline)
                        Text("Author: \(item.author)").font(.caption)
                    }
                }
            }
            .blur(radius: viewModel.isLoading ? 3 : 0)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert(item: $viewModel.activeAlert) { activeAlert in
            switch activeAlert {
            case .alert(let alertItem):
                return Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text("OK"))
                )
            case .notify(let notifyItem):
                return Alert(
                    title: Text(notifyItem.title),
                    message: Text(notifyItem.message),
                    primaryButton: .default(Text("OK"), action: notifyItem.primaryAction),
                    secondaryButton: .cancel(Text("Cancel"), action: notifyItem.secondaryAction ?? {})
                )
            }
        }
    }
}
