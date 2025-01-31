import SwiftUI

/// A view that provides action buttons for saving and resetting a dictionary filter.
///
/// This view displays two buttons:
/// - **Save**: Triggers the `onSave` action.
/// - **Reset**: Triggers the `onReset` action.
struct DictionaryRemoteFilterViewActions: View {
    
    // MARK: - Properties
    
    /// Closure to execute when the save button is pressed.
    let onSave: () -> Void
    
    /// Closure to execute when the reset button is pressed.
    let onReset: () -> Void
    
    /// Localization support for button titles.
    private let locale: DictionaryRemoteFilterLocale
    
    // MARK: - Initialization
    
    /// Initializes the view with localized titles and action handlers.
    /// - Parameters:
    ///   - locale: The localization object providing button titles.
    ///   - onSave: A closure executed when the save button is tapped.
    ///   - onReset: A closure executed when the reset button is tapped.
    init(
        locale: DictionaryRemoteFilterLocale,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void
    ) {
        self.locale = locale
        self.onSave = onSave
        self.onReset = onReset
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.saveTitle,
                action: onSave
            )
            
            ButtonAction(
                title: locale.resetTitle,
                action: onReset
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
