import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: GreetingViewModel
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var currentLanguage: String = "en"
    @State private var showSettings = false

    init() {
        let appState = AppState.shared
        let apiManager = appState.apiManager
        let logger = appState.logger
        _viewModel = StateObject(wrappedValue: GreetingViewModel(apiManager: apiManager, logger: logger))
    }

    // Вычисляемые свойства для локализованных строк
    var greetingText: String {
        localizationManager.localizedString(for: "greeting")
    }

    var fetchDictionaryText: String {
        localizationManager.localizedString(for: "fetch_dictionary")
    }

    var fetchDownloadText: String {
        localizationManager.localizedString(for: "fetch_download")
    }

    var changeLanguageText: String {
        localizationManager.localizedString(for: "change_language")
    }

    var switchThemeText: String {
        themeManager.currentTheme is LightTheme ? "Switch to Dark Theme" : "Switch to Light Theme"
    }

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text(viewModel.message)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Text(greetingText)
                        .foregroundColor(themeManager.currentTheme.textColor)

                    Button(action: {
                        viewModel.fetchDictionary()
                    }) {
                        Text(fetchDictionaryText)
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    Button(action: {
                        viewModel.fetchDownload()
                    }) {
                        Text(fetchDownloadText)
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    // Кнопка смены языка
                    Button(action: {
                        toggleLanguage()
                    }) {
                        Text(changeLanguageText)
                    }
                    .padding()
                    .background(themeManager.currentTheme.accentColor)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(8)

                    // Кнопка переключения темы
                    Button(action: {
                        themeManager.toggleTheme()
                    }) {
                        Text(switchThemeText)
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
                            Text(String(format: localizationManager.localizedString(for: "author"), item.author))
                                .font(.caption)
                                .foregroundColor(themeManager.currentTheme.textColor)
                        }
                        .listRowBackground(themeManager.currentTheme.backgroundColor)
                    }
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
                    .environmentObject(localizationManager)
            }
            .alert(item: $viewModel.activeAlert) { activeAlert in
                // Обработка алертов
                switch activeAlert {
                case .alert(let alertItem):
                    return Alert(
                        title: Text(localizationManager.localizedString(for: alertItem.title)),
                        message: Text(localizationManager.localizedString(for: alertItem.message)),
                        dismissButton: .default(Text(localizationManager.localizedString(for: "ok")))
                    )
                case .notify(let notifyItem):
                    return Alert(
                        title: Text(localizationManager.localizedString(for: notifyItem.title)),
                        message: Text(localizationManager.localizedString(for: notifyItem.message)),
                        primaryButton: .default(Text(localizationManager.localizedString(for: "ok")), action: notifyItem.primaryAction),
                        secondaryButton: .cancel(Text(localizationManager.localizedString(for: "cancel")), action: notifyItem.secondaryAction ?? {})
                    )
                }
            }
            .onAppear {
                self.currentLanguage = appState.settingsManager.settings.language
            }
        }
    }

    private func toggleLanguage() {
        let newLanguage = currentLanguage == "en" ? "ru" : "en"
        appState.settingsManager.settings.language = newLanguage
        currentLanguage = newLanguage
    }
}
