import SwiftUI

internal struct DictionaryRemoteFilterViewSort: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var selectedSortBy: ApiSortType
    
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle

    /// Initializes the DictionaryRemoteFilterViewSort.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - selectedSortBy: Binding for the selected sorting option.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        selectedSortBy: Binding<ApiSortType>
    ) {
        self._selectedSortBy = selectedSortBy
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        SectionHeader(
            title: locale.screenSubtitleSortBy,
            style: .block(themeManager.currentThemeStyle)
        )
        ItemPicker(
            selectedValue: $selectedSortBy,
            items: ApiSortType.allCases,
            content:  {
                sortBy in Text(sortBy.name)
            },
            style: .themed(themeManager.currentThemeStyle, type: .segmented)
        )
    }
}
