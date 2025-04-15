import SwiftUI

struct DictionaryNearBy: View {
    @Binding var isPresented: Bool
    let onComplete: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    @StateObject private var dictionaryGetter = DictionaryGetter()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    @State private var selectedDictionary: DatabaseModelDictionary?
    @StateObject private var locale = DictionarySendLocale()
    @StateObject private var style: DictionarySendStyle

    @State private var isPressedTrailing = false

    init(
        isPresented: Binding<Bool>,
        onComplete: @escaping () -> Void,
        style: DictionarySendStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._isPresented = isPresented
        self.onComplete = onComplete
        _style = StateObject(wrappedValue: style)
    }

    var body: some View {
        NavigationStack {
            BaseScreen(screen: .DictionarySend, title: locale.screenTitle) {
                VStack {
                    Text("DictionaryNearBy")
                    
                    DictionaryNearByViewList(
                        style: style,
                        locale: locale,
                        dictionaryGetter: dictionaryGetter,
                        dictionaryAction: dictionaryAction,
                        onDictionarySelect: { dictionary in selectedDictionary = dictionary  }
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ButtonNav(
                            isPressed: $isPressedTrailing,
                            onTap: {
                                isPresented = false
                                onComplete()
                            },
                            style: .close(themeManager.currentThemeStyle)
                        )
                    }
                }
                .onAppear {
                    dictionaryAction.setScreen(.DictionaryLocalList)
                    dictionaryGetter.setScreen(.DictionaryLocalList)
                    if dictionaryGetter.dictionaries.isEmpty {
                        dictionaryGetter.resetPagination()
                    }
                }
                .onDisappear() {
                    dictionaryGetter.searchText = ""
                    dictionaryGetter.clear()
                }
                .sheet(item: $selectedDictionary) { dictionary in
                    DictionaryLocalDetails(
                        dictionary: dictionary,
                        refresh: { dictionaryGetter.resetPagination() }
                    )
                }
            }
        }
    }
}
