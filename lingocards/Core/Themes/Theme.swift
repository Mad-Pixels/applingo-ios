import SwiftUI

protocol Theme {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var accentColor: Color { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
}
