import SwiftUI

func CompAlertView(
    title: String,
    message: String,
    closeAction: @escaping () -> Void,
    theme: ThemeStyle
    
) -> Alert {
    return Alert(
        title: Text(title),
        message: Text(message),
        dismissButton: .default(Text("Close"), action: closeAction)
    )
}
