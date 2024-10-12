import SwiftUI

struct CompDictionaryPickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedDictionary: DictionaryItem?
    var dictionaries: [DictionaryItem]

    var body: some View {
        Section() {
            Picker("Select Dictionary", selection: $selectedDictionary) {
                ForEach(dictionaries, id: \.id) { dictionary in
                    Text(dictionary.displayName)
                        .tag(dictionary as DictionaryItem?)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}
