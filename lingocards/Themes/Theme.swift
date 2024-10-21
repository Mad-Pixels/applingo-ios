import SwiftUI

protocol ThemeStyle {
    var backgroundViewColor: Color { get }
    var backgroundBlockColor: Color { get }
    var headerBlockTextColor: Color { get }
    var secondaryIconColor: Color { get }
    var errorTextColor: Color { get }
    var fieldTextColor: Color { get }
    var baseTextColor: Color { get }
    
    //
    
    
    
    var backgroundColor: Color { get }
    
    var textColor: Color { get }
    var primaryButtonColor: Color { get }
    var secondaryButtonColor: Color { get }
    var navigationBarColor: Color { get }
}
