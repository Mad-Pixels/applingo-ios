import SwiftUI

struct ContentView: View {
    // StateObject для хранения и управления состоянием ViewModel
    @StateObject private var viewModel: GreetingViewModel
    // EnvironmentObject для доступа к глобальному состоянию приложения
    @EnvironmentObject private var appState: AppState
    
    // Инициализатор для создания ViewModel с зависимостями
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Отображение сообщения о статусе
                Text(viewModel.message)
                
                // Кнопка для загрузки словаря
                Button("Fetch Dictionary") {
                    viewModel.fetchDictionary()
                }
                
                // Кнопка для загрузки файла
                Button("Fetch Download") {
                    viewModel.fetchDownload()
                }
                
                // Список элементов словаря
                List(viewModel.dictionaryItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.description).font(.subheadline)
                        Text("Author: \(item.author)").font(.caption)
                    }
                }
            }
            // Применение эффекта размытия при загрузке
            .blur(radius: viewModel.isLoading ? 3 : 0)
            
            // Отображение индикатора загрузки
            if viewModel.isLoading {
                ProgressView()
            }
        }
        // Отображение алерта для сообщений об ошибках
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
        }
        // Отображение алерта для уведомлений с действиями
        .alert(item: $viewModel.notifyItem) { notifyItem in
            Alert(
                title: Text(notifyItem.title),
                message: Text(notifyItem.message),
                primaryButton: .default(Text("OK"), action: notifyItem.primaryAction),
                secondaryButton: .cancel(Text("Cancel"), action: notifyItem.secondaryAction ?? {})
            )
        }
    }
}

// Представление для отображения уведомления (в данный момент не используется из-за изменения на Alert)
struct NotifyView: View {
    // Элемент уведомления для отображения
    let item: NotifyItem
    // Environment для управления презентацией представления
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(item.title).font(.headline)
            Text(item.message)
            HStack {
                // Кнопка OK с основным действием
                Button("OK") {
                    item.primaryAction()
                    presentationMode.wrappedValue.dismiss()
                }
                // Опциональная кнопка Cancel с вторичным действием
                if let secondaryAction = item.secondaryAction {
                    Button("Cancel") {
                        secondaryAction()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .padding()
    }
}
