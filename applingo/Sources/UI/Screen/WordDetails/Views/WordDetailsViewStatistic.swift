import SwiftUI

struct WordDetailsViewStatistic: View {
    private let word: WordItemModel
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    init(
        word: WordItemModel,
        locale: WordDetailsLocale,
        style: WordDetailsStyle
    ) {
        self.word = word
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        Section(header: Text(locale.statisticsTitle)) {
            VStack(alignment: .leading, spacing: style.spacing) {
                ChartBar(
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
