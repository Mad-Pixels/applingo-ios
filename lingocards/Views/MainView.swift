import SwiftUI

struct MainView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab: AppFrameModel = .learn
    
    init() {
        configureInitialTabBarAppearance()
    }

    var body: some View {
        TabView {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Learn").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(AppFrameModel.learn)

            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(AppFrameModel.tabDictionaries)

            TabWordsView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(AppFrameModel.tabWords)

            TabSettingsView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(AppFrameModel.tabSettings)
        }
        .id(themeManager.currentTheme)
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
        .onAppear {
            configureTabBarAppearance()
        }
        .onChange(of: themeManager.currentTheme) { _ in
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        DispatchQueue.main.async {
            configureInitialTabBarAppearance()
        }
    }
    
    private func configureInitialTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ThemeManager.shared.currentThemeStyle.backgroundViewColor)

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ThemeManager.shared.currentThemeStyle.secondaryIconColor)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ThemeManager.shared.currentThemeStyle.secondaryTextColor)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ThemeManager.shared.currentThemeStyle.accentColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ThemeManager.shared.currentThemeStyle.accentColor)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
