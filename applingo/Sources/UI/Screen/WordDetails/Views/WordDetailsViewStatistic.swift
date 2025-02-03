import SwiftUI

/// A view that displays statistics for the word,
/// such as success and fail counts represented via a donut chart.
struct WordDetailsViewStatistic: View {
    
    // MARK: - Properties
    private let word: DatabaseModelWord
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    // MARK: - Initializer
    /// Initializes the statistic view.
    /// - Parameters:
    ///   - word: The word model.
    ///   - locale: Localization object.
    ///   - style: Style configuration.
    init(
        word: DatabaseModelWord,
        locale: WordDetailsLocale,
        style: WordDetailsStyle
    ) {
        self.word = word
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.statisticsTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                DonutChart(
                    data: [
                        DonutChartModel(value: Double(word.fail), label: "fail", color: .red),
                        DonutChartModel(value: Double(word.success), label: "success", color: .green)
                    ],
                    centerValue: "\(word.weight)"
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
