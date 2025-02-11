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
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
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
            .padding(.horizontal, style.paddingBlock)
        }
    }
}
