import SwiftUI

struct CompToolbarMenu: View {
    struct MenuItem {
        let title: String
        let systemImage: String
        let action: () -> Void
    }
    
    let items: [MenuItem]
    let theme: ThemeStyle

    var body: some View {
        Menu {
            ForEach(items.indices, id: \.self) { index in
                Button(action: items[index].action) {
                    Label(items[index].title, systemImage: items[index].systemImage)
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(theme.accentColor)
        }
    }
}
