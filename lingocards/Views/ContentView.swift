import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var currentLanguage: String = LocalizationService.shared.manager?.currentLanguage() ?? "en"
    @State private var showSettings = false // Добавили переменную для управления показом настроек

    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
    }

    var body: some View {
        NavigationView { // Оборачиваем контент в NavigationView
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Устанавливаем цвет фона из текущей темы

                VStack {
                    Text(viewModel.message)
                        .foregroundColor(themeManager.currentTheme.textColor) // Устанавливаем цвет текста из темы
                    Text("greeting".localized())
                        .foregroundColor(themeManager.currentTheme.textColor)

                    Button("fetch_dictionary".localized()) {
                        viewModel.fetchDictionary()
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    Button("fetch_download".localized()) {
                        viewModel.fetchDownload()
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    // Кнопка смены языка
                    Button("change_language".localized()) {
                        toggleLanguage()
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    // Кнопка переключения темы
                    Button(themeManager.currentTheme is LightTheme ? "Switch to Dark Theme" : "Switch to Light Theme") {
                        themeManager.toggleTheme()
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    List(viewModel.dictionaryItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                                .foregroundColor(themeManager.currentTheme.textColor)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(themeManager.currentTheme.textColor)
                            Text("author".localized(arguments: item.author))
                                .font(.caption)
                                .foregroundColor(themeManager.currentTheme.textColor)
                        }
                        .listRowBackground(themeManager.currentTheme.backgroundColor)
                    }
                }
                .blur(radius: viewModel.isLoading ? 3 : 0)
            }
            .navigationBarTitle("Home", displayMode: .inline) // Указываем заголовок
            .navigationBarItems(trailing: Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .foregroundColor(themeManager.currentTheme.accentColor)
            })
            .sheet(isPresented: $showSettings) {
                SettingsView(settingsManager: appState.settingsManager)
                    .environmentObject(appState)
                    .environmentObject(appState.themeManager)
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
