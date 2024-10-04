import SwiftUI

protocol Theme {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var accentColor: Color { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
}

extension Theme {
    var buttonFont: Font { Font.system(size: 16, weight: .bold, design: .default) } // Значение по умолчанию
}
