import SwiftUI

internal struct DictionaryRemoteFilterViewActions: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
        
    private let onSave: () -> Void
    private let onReset: () -> Void
    
    /// Initializes the view with localized titles and action handlers.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - onSave: A closure executed when the save button is tapped.
    ///   - onReset: A closure executed when the reset button is tapped.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void
    ) {
        self.locale = locale
        self.style = style
        self.onSave = onSave
        self.onReset = onReset
    }
    
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.screenButtonReset,
                action: onReset,
                style: .action(themeManager.currentThemeStyle)
            )
            
            ButtonAction(
                title: locale.screenButtonSave,
                action: onSave,
                style: .action(themeManager.currentThemeStyle)
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .padding(.top, 5)
    }
}
