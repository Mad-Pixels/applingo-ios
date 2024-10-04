import SwiftUI

struct LearnView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localizationManager: LocalizationManager // Наблюдаем напрямую за LocalizationManager

    var body: some View {
        VStack {
            Text(localizationManager.localizedString(for: "greeting"))
                .font(.largeTitle)
                .padding()
        }
    }
}
