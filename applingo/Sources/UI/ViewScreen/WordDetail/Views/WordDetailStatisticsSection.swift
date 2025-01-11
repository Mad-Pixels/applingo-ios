import SwiftUI

struct WordDetailStatisticsSection: View {
    private let word: WordItemModel
    private let locale: ScreenWordDetailLocale
    private let style: ScreenWordDetailStyle
    
    init(
        word: WordItemModel,
        locale: ScreenWordDetailLocale,
        style: ScreenWordDetailStyle
    ) {
        self.word = word
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        Section(header: Text(locale.statisticsTitle)) {
            VStack(alignment: .leading, spacing: style.spacing) {
                BarChart(
                    title: locale.answersTitle,
                    data: [
                        BarData(value: Double(word.fail), label: "fail", color: .red),
                        BarData(value: Double(word.success), label: "success", color: .green)
                    ]
                )
            }
            .padding(style.padding)
        }
    }
}
