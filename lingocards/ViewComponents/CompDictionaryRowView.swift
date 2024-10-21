import SwiftUI

struct CompDictionaryRowView: View {
    let dictionary: DictionaryItem
    let onTap: () -> Void
    let onToggle: (Bool) -> Void
    let theme: ThemeStyle

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dictionary.displayName)
                    .font(.headline)
                    .foregroundColor(theme.textColor)

                Text(dictionary.subTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }

            Toggle(isOn: Binding(
                get: { dictionary.isActive },
                set: { newStatus in
                    onToggle(newStatus)
                })
            ) {
                EmptyView()
            }
            .toggleStyle(CheckboxToggleStyle())
        }
    }
}
