import SwiftUI

#Preview("Word Add Screen") {
    WordAddManual(
        isPresented: .constant(true),
        refresh: {}
    )
    .environmentObject(ThemeManager.shared)
}
