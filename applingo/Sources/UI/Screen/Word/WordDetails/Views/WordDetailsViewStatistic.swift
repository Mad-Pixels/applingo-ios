import SwiftUI

internal struct WordDetailsViewStatistic: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var word: DatabaseModelWord
    
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    
    /// Initializes the WordDetailsViewStatistic.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    ///   - word: A binding to the `DatabaseModelWord` object being edited or displayed.
    init(
        style: WordDetailsStyle,
        locale: WordDetailsLocale,
        word: Binding<DatabaseModelWord>
    ) {
        self.style = style
        self.locale = locale
        
        self._word = word
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleStatistic,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                if word.fail == 0 && word.success == 0 {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenSubtitleNoData),
                        style: .headerMain(
                            themeManager.currentThemeStyle,
                            alignment: .center,
                            lineLimit: 1
                        )
                    )
                    .padding(.bottom, -16)
                    
                    Image(warningImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: style.iconSize, height: style.iconSize)
                } else {
                    SectionBody(
                        content:  {
                            DonutChart(
                                data: [
                                    DonutChartModel(
                                        value: Double(word.success),
                                        label: locale.screenDescriptionCorrectAnswers,
                                        color: themeManager.currentThemeStyle.success
                                    ),
                                    DonutChartModel(
                                        value: Double(word.fail),
                                        label: locale.screenDescriptionWrongAnswers,
                                        color: themeManager.currentThemeStyle.error
                                    )
                                ],
                                centerValue: "\(Int(ceil(Double(word.weight) / 100.0))) / 10",
                                legendTitle: locale.screenSubtitleStatisticCount
                            )
                        }, style: .block(themeManager.currentThemeStyle))
                }
            }
            .padding(.horizontal, style.paddingBlock)
        }
    }
    
    /// Determines the warning image name based on the current theme.
    private var warningImageName: String {
        themeManager.currentTheme.asString == "Dark" ? "no_word_stat" : "no_word_stat"
    }
}
