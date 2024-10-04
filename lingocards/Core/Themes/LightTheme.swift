import SwiftUI

struct LightTheme: Theme {
    let backgroundColor: Color = Color.white
    let textColor: Color = Color.black
    let accentColor: Color = Color.blue
    let userInterfaceStyle: UIUserInterfaceStyle = .light
    let buttonFont: Font = Font.system(size: 16, weight: .bold, design: .default) // Определяем шрифт кнопки
}
