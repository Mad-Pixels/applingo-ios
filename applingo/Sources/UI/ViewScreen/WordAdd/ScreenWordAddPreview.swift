import SwiftUI

#Preview("Word Add Screen") {
    ScreenWordAdd(
        isPresented: .constant(true),
        refresh: {}
    )
    .environmentObject(ThemeManager.shared)
}
