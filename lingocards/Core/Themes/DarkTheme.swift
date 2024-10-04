import SwiftUI

struct DarkTheme: Theme {
    let backgroundColor: Color = Color.black
    let textColor: Color = Color.white
    let accentColor: Color = Color.orange
    let userInterfaceStyle: UIUserInterfaceStyle = .dark
    let buttonFont: Font = Font.system(size: 16, weight: .bold, design: .default) // Определяем шрифт кнопки
}
