import SwiftUI

struct LearnView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var viewModel = LearnViewModel()

    var body: some View {
        VStack {
            Text(localizationManager.localizedString(for: "greeting"))
                            .font(.largeTitle)
                            .padding()
            

            // Здесь можно добавить другие элементы UI для этой вкладки
        }
        .alert(item: $viewModel.activeAlert) { activeAlert in
            switch activeAlert {
            case .alert(let alertItem):
                return Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text("OK"))
                )
            case .notify(let notifyItem):
                return Alert(
                    title: Text(notifyItem.title),
                    message: Text(notifyItem.message),
                    primaryButton: .default(Text("OK"), action: notifyItem.primaryAction),
                    secondaryButton: .cancel(Text("Cancel"), action: notifyItem.secondaryAction ?? {})
                )
            }
        }
    }
}
