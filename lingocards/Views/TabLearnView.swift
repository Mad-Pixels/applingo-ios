import SwiftUI

struct TabLearnView: View {
    @EnvironmentObject var frameManager: FrameManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        let theme = themeManager.currentThemeStyle
        
        VStack {
            Text("testLearn")
                .font(.largeTitle)
                .padding()
                .foregroundColor(theme.baseTextColor) // Цвет текста по теме
            
            // Контент для вкладки "Learn"
            Text("This is the Learn View")
                .font(.title)
                .foregroundColor(theme.accentColor) // Цвет основного текста по теме
            
            Button("Log Error") {
                Logger.error("Ошибка подключения к серверу", type: .network, additionalInfo: ["URL": "https://example.com", "Timeout": "30"])
                // Лог на уровне error
            }
            .padding()
            .background(theme.baseTextColor) // Цвет кнопки по теме
            .foregroundColor(theme.baseTextColor) // Цвет текста кнопки по теме
            .cornerRadius(8)
        }
        .background(theme.backgroundViewColor) // Фон по теме
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            frameManager.setActiveFrame(.learn)
        }
//        .modifier(FrameModifier(activeFrame: frameManager.activeFrame) { newFrame in
//            if newFrame != .learn {
//                frameManager.deactivateFrame(.learn)
//            }
//        })
    }
}
