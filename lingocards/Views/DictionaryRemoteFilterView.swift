import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Временно отображаем "Hello World"
                Text("Hello World")
                    .font(.largeTitle)
                    .padding()

                Spacer()
            }
            .navigationTitle(languageManager.localizedString(for: "Filter").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
            })
        }
    }
}
