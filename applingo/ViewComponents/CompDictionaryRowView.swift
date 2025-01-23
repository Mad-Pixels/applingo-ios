//import SwiftUI
//
//struct CompDictionaryRowView: View {
//    let dictionary: DictionaryItemModel
//    let onTap: () -> Void
//    let onToggle: (Bool) -> Void
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(dictionary.displayName)
//                    .font(.headline)
//                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
//
//                Text(dictionary.subTitle)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.vertical, 4)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                onTap()
//            }
//
//            Toggle(isOn: Binding(
//                get: { dictionary.isActive },
//                set: { newStatus in
//                    onToggle(newStatus)
//                })
//            ) {
//                EmptyView()
//            }
//            .toggleStyle(BaseCheckboxStyle())
//        }
//    }
//}
