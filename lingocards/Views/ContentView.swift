import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    @EnvironmentObject private var appState: AppState
    @State private var currentLanguage: String = LocalizationService.shared.manager?.currentLanguage() ?? "en"
    
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.message)
                Text("greeting".localized())
                
                Button("fetch_dictionary".localized()) {
                    viewModel.fetchDictionary()
                }
                
                Button("fetch_download".localized()) {
                    viewModel.fetchDownload()
                }
                
                // Кнопка смены языка
                Button("change_language".localized()) {
                    toggleLanguage()
                }
                .padding()
                
                List(viewModel.dictionaryItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.description).font(.subheadline)
                        Text("author".localized(arguments: item.author)).font(.caption)
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
                    title: Text(alertItem.title.localized()),
                    message: Text(alertItem.message.localized()),
                    dismissButton: .default(Text("ok".localized()))
                )
            case .notify(let notifyItem):
                return Alert(
                    title: Text(notifyItem.title.localized()),
                    message: Text(notifyItem.message.localized()),
                    primaryButton: .default(Text("ok".localized()), action: notifyItem.primaryAction),
                    secondaryButton: .cancel(Text("cancel".localized()), action: notifyItem.secondaryAction ?? {})
                )
            }
        }
    }
    
    private func toggleLanguage() {
        guard let manager = LocalizationService.shared.manager else { return }
        
        // Переключаем язык между английским и русским
        let newLanguage = currentLanguage == "en" ? "ru" : "en"
        manager.setLanguage(newLanguage)
        currentLanguage = newLanguage
        
        // Обновляем UI
        viewModel.objectWillChange.send()
    }
}
