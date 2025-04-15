import SwiftUI

struct DictionaryNearByDescription: View {
    @Binding var isPresented: Bool // <-- привязываем к внешнему

    @EnvironmentObject private var themeManager: ThemeManager

    @StateObject private var locale = DictionarySendLocale()
    @StateObject private var style: DictionarySendStyle

    @State private var isPressedTrailing = false
    @State private var isShowingNearby = false

    init(
        isPresented: Binding<Bool>,
        style: DictionarySendStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._isPresented = isPresented
        _style = StateObject(wrappedValue: style)
    }

    var body: some View {
        NavigationStack {
            BaseScreen(screen: .DictionarySend, title: locale.screenTitle) {
                VStack(spacing: 24) {
                    Text("Отправляйте словари поблизости")
                        .font(.title2).bold()

                    Text("Поднесите устройства друг к другу, чтобы отправить словарь без интернета.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    Button(action: {
                        isShowingNearby = true
                    }) {
                        Text("Включить Nearby")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 40)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        isPressed: $isPressedTrailing,
                        onTap: { isPresented = false },
                        style: .close(themeManager.currentThemeStyle)
                    )
                }
            }
            .sheet(isPresented: $isShowingNearby) {
                DictionaryNearBy(
                    isPresented: $isShowingNearby,
                    onComplete: {
                        // Закрываем оба окна
                        isPresented = false
                    }
                )
            }
        }
    }
}
