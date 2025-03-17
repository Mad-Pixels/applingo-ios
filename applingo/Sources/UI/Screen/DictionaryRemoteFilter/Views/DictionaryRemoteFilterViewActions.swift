import SwiftUI

/// A view that provides action buttons for saving and resetting a dictionary filter.
///
/// This view displays two buttons:
/// - **Save**: Triggers the `onSave` action.
/// - **Reset**: Triggers the `onReset` action.
struct DictionaryRemoteFilterViewActions: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
        
    let onSave: () -> Void
    let onReset: () -> Void
    
    // MARK: - Initialization
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
    
    // MARK: - Body
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.screenButtonSave,
                action: onSave,
                style: .action(themeManager.currentThemeStyle)
            )
            
            ButtonAction(
                title: locale.screenButtonReset,
                action: onReset,
                style: .action(themeManager.currentThemeStyle)
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .padding(.top, 5)
    }
}
