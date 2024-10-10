import SwiftUI

struct DictionaryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isShowingRemoteList = false
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                importCSV()
            }) {
                Text(languageManager.localizedString(for: "Import CSV").capitalizedFirstLetter)
                    .font(.title2)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                isShowingRemoteList = true // Переход на новый экран
            }) {
                Text(languageManager.localizedString(for: "Download").capitalizedFirstLetter)
                    .font(.title2)
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .fullScreenCover(isPresented: $isShowingRemoteList) {
            DictionaryRemoteList()
                .ignoresSafeArea()
                .interactiveDismissDisabled(true) // Отключаем свайп вниз
        }
        .navigationTitle(languageManager.localizedString(for: "Add Dictionary").capitalizedFirstLetter)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }

    private func importCSV() {
        // Логика для импорта CSV
    }
}
