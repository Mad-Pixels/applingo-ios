import SwiftUI

/// Протокол, определяющий свойства темы
protocol Theme {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var accentColor: Color { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
    // Добавьте другие цвета и стили по необходимости
}
