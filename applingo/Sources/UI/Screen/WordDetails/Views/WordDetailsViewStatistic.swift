import SwiftUI

/// A view that displays statistics for a word,
/// such as success and fail counts represented via a donut chart.
struct WordDetailsViewStatistic: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    private let word: DatabaseModelWord
    
    // MARK: - Initializer
    /// Initializes the statistic view.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    ///   - word: The word model.
    init(
        style: WordDetailsStyle,
        locale: WordDetailsLocale,
        word: DatabaseModelWord
    ) {
        self.style = style
        self.locale = locale
        self.word = word
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleStatistic,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                if word.fail == 0 && word.success == 0 {
                    Text(locale.screenSubtitleNoData)
                        .font(style.titleFont)
                    Image(warningImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: style.iconSize, height: style.iconSize)
                } else {
                    SectionBody(
                        style: .area(themeManager.currentThemeStyle)
                    ) {
                        DonutChart(
                            data: [
                                DonutChartModel(
                                    value: Double(word.success),
                                    label: locale.screenDescriptionCorrectAnswers,
                                    color: themeManager.currentThemeStyle.success
                                ),
                                DonutChartModel(
                                    value: Double(word.fail),
                                    label: locale.screenDesctiptionWrongAnswers,
                                    color: themeManager.currentThemeStyle.error
                                )
                            ],
                            centerValue: "\(Int(ceil(Double(word.weight) / 100.0))) / 10",
                            style: .themed(themeManager.currentThemeStyle),
                            legendTitle: locale.screenSubtitleStatisticCount
                        )
                    }
                }
            }
            .padding(.horizontal, style.paddingBlock)
        }
    }
    
    // MARK: - Computed Properties
    /// Determines the warning image name based on the current theme.
    private var warningImageName: String {
        themeManager.currentTheme.asString == "Dark" ? "no_word_stat" : "no_word_stat"
    }
}
