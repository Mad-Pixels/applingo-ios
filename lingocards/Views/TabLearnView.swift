import SwiftUI

struct TabLearnView: View {
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        let theme = themeManager.currentThemeStyle
        
        VStack {
            Text("testLearn")
                .font(.largeTitle)
                .padding()
                .foregroundColor(theme.textColor) // Цвет текста по теме
            
            // Контент для вкладки "Learn"
            Text("This is the Learn View")
                .font(.title)
                .foregroundColor(theme.primaryButtonColor) // Цвет основного текста по теме
            
            Button("Log Error") {
                Logger.error("Ошибка подключения к серверу", type: .network, additionalInfo: ["URL": "https://example.com", "Timeout": "30"])
                // Лог на уровне error
            }
            .padding()
            .background(theme.primaryButtonColor) // Цвет кнопки по теме
            .foregroundColor(theme.textColor) // Цвет текста кнопки по теме
            .cornerRadius(8)
        }
        .background(theme.backgroundColor) // Фон по теме
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            tabManager.setActiveTab(.learn)
        }
        .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
            if newTab != .learn {
                tabManager.deactivateTab(.learn)
            }
        })
    }
}
