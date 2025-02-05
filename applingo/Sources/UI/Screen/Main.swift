import SwiftUI

struct Main: View {
    @ObservedObject private var locale = LocaleManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab: Int = 0

    var body: some View {
        AppTab(theme: themeManager.currentTheme, style: .default) {
            TabView(selection: $selectedTab) {
                Home()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(
                                locale.localizedString(
                                    for: "tab.general.title"
                                ).capitalizedFirstLetter
                            )
                        } icon: {
                            Image(systemName: "rectangle.grid.2x2.fill")
                        }
                    }
                    .tag(0)

                WordList()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(
                                locale.localizedString(
                                    for: "tab.word.title"
                                ).capitalizedFirstLetter
                            )
                        } icon: {
                            Image(systemName: "text.magnifyingglass")
                        }
                    }
                    .tag(1)

                DictionaryLocalList()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(
                                locale.localizedString(
                                    for: "tab.dictionary.title"
                                ).capitalizedFirstLetter
                            )
                        } icon: {
                            Image(systemName: "doc.text.fill.viewfinder")
                        }
                    }
                    .tag(2)

                Settings()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(
                                locale.localizedString(
                                    for: "tab.settings.title"
                                ).capitalizedFirstLetter
                            )
                        } icon: {
                            Image(systemName: "gearshape.2.fill")
                        }
                    }
                    .tag(3)
            }
        }
    }
}
