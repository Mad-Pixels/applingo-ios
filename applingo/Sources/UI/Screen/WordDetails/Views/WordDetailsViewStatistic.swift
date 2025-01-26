import SwiftUI

struct WordDetailsViewStatistic: View {
    private let word: DatabaseModelWord
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    init(
        word: DatabaseModelWord,
        locale: WordDetailsLocale,
        style: WordDetailsStyle
    ) {
        self.word = word
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.statisticsTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                ChartBar(
                    title: locale.answersTitle,
                    data: [
                        ChartBarModel(value: Double(word.fail), label: "fail", color: .red),
                        ChartBarModel(value: Double(word.success), label: "success", color: .green)
                    ]
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
