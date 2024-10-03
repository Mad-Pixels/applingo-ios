import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var currentLanguage: String = "en"
    @State private var showSettings = false

    init() {
        if let appState = AppState.shared {
            let apiManager = appState.apiManager
            let logger = appState.logger
            _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
        } else {
            fatalError("AppState.shared не инициализирован")
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text(viewModel.message)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Text("greeting".localized())
                        .foregroundColor(themeManager.currentTheme.textColor)

                    // Остальной код...

                }
                .blur(radius: viewModel.isLoading ? 3 : 0)
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .foregroundColor(themeManager.currentTheme.accentColor)
            })
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(appState)
                    .environmentObject(themeManager)
            }
            .alert(item: $viewModel.activeAlert) { activeAlert in
                // Обработка алертов
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
            .onAppear {
                // Теперь можем безопасно использовать appState
                self.currentLanguage = appState.settingsManager.settings.language
            }
        }
    }

    private func toggleLanguage() {
        // Обновляем язык через settingsManager
        let newLanguage = currentLanguage == "en" ? "ru" : "en"
        appState.settingsManager.settings.language = newLanguage
        currentLanguage = newLanguage
    }
}
