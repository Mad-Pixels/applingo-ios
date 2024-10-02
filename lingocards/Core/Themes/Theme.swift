import UIKit

protocol Theme {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var accentColor: UIColor { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
    // Добавьте другие цвета и стили по необходимости
}
