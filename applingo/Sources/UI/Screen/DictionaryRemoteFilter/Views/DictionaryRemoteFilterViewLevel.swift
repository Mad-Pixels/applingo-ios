import SwiftUI

internal struct DictionaryRemoteFilterViewLevel: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var selectedLevel: DictionaryLevelType
    
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
    
    /// Initializes the DictionaryRemoteFilterViewLevel.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - selectedLevel: Binding for the selected dictionary level.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        selectedLevel: Binding<DictionaryLevelType>
    ) {
        self._selectedLevel = selectedLevel
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleLevel,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
        
            VStack(spacing: style.spacing) {
                ItemPicker(
                    selectedValue: $selectedLevel,
                    items: DictionaryLevelType.allCases
                ) { level in
                    Text(getFormattedLevelName(for: level))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, style.spacing)
            .background(Color.clear)
        }
    }
    
    /// Returns formatted level name with localized title and code.
    private func getFormattedLevelName(for level: DictionaryLevelType) -> String {
        if level == .undefined {
            return locale.screenTextUFOLevel
        }
        
        let localizedName = getLocalizedLevelName(for: level)
        return "\(localizedName) (\(level.rawValue))"
    }
    
    /// Returns localized name for dictionary level.
    private func getLocalizedLevelName(for level: DictionaryLevelType) -> String {
        switch level {
        case .undefined:
            return locale.screenTextUFOLevel
        case .beginner:
            return locale.screenTextBeginnerLevel
        case .elementary:
            return locale.screenTextElementaryLevel
        case .intermediate:
            return locale.screenTextIntermediateLevel
        case .upperIntermediate:
            return locale.screenTextUpperIntermediateLevel
        case .advanced:
            return locale.screenTextAdvancedLevel
        case .proficient:
            return locale.screenTextProficientLevel
        }
    }
}
