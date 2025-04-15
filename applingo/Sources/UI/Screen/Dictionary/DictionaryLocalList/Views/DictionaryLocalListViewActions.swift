import SwiftUI

internal struct DictionaryLocalListViewActions: View {    
    private let locale: DictionaryLocalListLocale
    private let style: DictionaryLocalListStyle
    
    internal let onNearbySend: () -> Void
    internal let onDownload: () -> Void
    internal let onImport: () -> Void
    
    /// Initializes the DictionaryLocalListViewActions.
    /// - Parameters:
    ///   - style: `DictionaryLocalListStyle` object that defines the visual style.
    ///   - locale: `DictionaryLocalListLocale` object that provides localized strings.
    ///   - onImport: Action closure for the import button.
    ///   - onDownload: Action closure for the download button.
    init(
        style: DictionaryLocalListStyle,
        locale: DictionaryLocalListLocale,
        onImport: @escaping () -> Void,
        onDownload: @escaping () -> Void,
        onNearbySend: @escaping () -> Void
    ) {
        self.onNearbySend = onNearbySend
        self.onDownload = onDownload
        self.onImport = onImport
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        let actions: [ButtonFloatingModelIconAction] = {
            var base = [
                ButtonFloatingModelIconAction(icon: "tray.and.arrow.down", action: onImport),
                ButtonFloatingModelIconAction(icon: "arrow.down.circle", action: onDownload)
            ]
            if NearbyAvailability.isAvailable {
                base.append(
                    ButtonFloatingModelIconAction(icon: "dot.radiowaves.left.and.right", action: onNearbySend)
                )
            }
            return base
        }()

        return ButtonFloatingMultiple(items: actions)
    }
}
