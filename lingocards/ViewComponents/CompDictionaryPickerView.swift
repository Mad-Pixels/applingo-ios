import SwiftUI

struct CompDictionaryPickerView: View {
    @Binding var selectedDictionary: DictionaryItem?
    var dictionaries: [DictionaryItem]

    var body: some View {
        Section(header: Text("Select Dictionary")) {
//            Picker("Select Dictionary", selection: $selectedDictionary) {
//                ForEach(dictionaries, id: \.id) { dictionary in
//                    Text(dictionary.displayName)
//                        .tag(dictionary as DictionaryItem?)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//            .onAppear {
//                Logger.debug("[CompDictionaryPickerView]: Dictionaries available: \(dictionaries)")
//            }
        }
    }
}
