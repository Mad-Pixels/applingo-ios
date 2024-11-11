import SwiftUI

struct CompBackgroundWordsView: View {
    @State private var backgroundWords: [(id: UUID, word: String, position: CGPoint, font: UIFont, opacity: Double)] = []
    
    private let languages = [
        "HELLO", "BONJOUR", "HOLA", "CIAO", "ПРИВЕТ", "HALLO", "你好", "こんにちは", "안녕하세요", "مرحبا",
        "LEARN", "APPRENDRE", "APRENDER", "IMPARARE", "УЧИТЬ", "LERNEN", "学习", "学ぶ", "배우다", "تعلم",
        "WORLD", "MONDE", "MUNDO", "MONDO", "МИР", "WELT", "世界", "世界", "세계", "عالم",
        "LANGUAGE", "LANGUE", "IDIOMA", "LINGUA", "ЯЗЫК", "SPRACHE", "语言", "言語", "언어", "لغة",
        "BOOK", "LIVRE", "LIBRO", "LIBRO", "КНИГА", "BUCH", "书", "本", "책", "كتاب",
        "WRITE", "ÉCRIRE", "ESCRIBIR", "SCRIVERE", "ПИСАТЬ", "SCHREIBEN", "写", "書く", "쓰다", "يكتب",
        "READ", "LIRE", "LEER", "LEGGERE", "ЧИТАТЬ", "LESEN", "读", "読む", "읽다", "يقرأ",
        "SPEAK", "PARLER", "HABLAR", "PARLARE", "ГОВОРИТЬ", "SPRECHEN", "说话", "話す", "말하다", "يتكلم",
        "STUDY", "ÉTUDIER", "ESTUDIAR", "STUDIARE", "УЧИТЬСЯ", "STUDIEREN", "学习", "勉強する", "공부하다", "يدرس",
        "KNOWLEDGE", "CONNAISSANCE", "CONOCIMIENTO", "CONOSCENZA", "ЗНАНИЕ", "WISSEN", "知识", "知識", "지식", "معرفة"
    ]
    
    private let padding: CGFloat = 2
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        GeometryReader { geometry in
            ZStack {
                ForEach(backgroundWords, id: \.id) { word in
                    Text(word.word)
                        .font(Font(word.font))
                        .position(word.position)
                        .foregroundColor(theme.secondaryTextColor.opacity(word.opacity))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                generateBackground(for: geometry.size)
            }
        }
    }
    
    private func generateBackground(for size: CGSize) {
        backgroundWords.removeAll()
        var occupiedRects: [CGRect] = []
        
        for _ in 0..<200 {
            let word = languages.randomElement() ?? "Hello"
            
            let fontSize = CGFloat.random(in: 14...42)
            let font: UIFont
            
            switch Int.random(in: 0...4) {
            case 0:
                font = .systemFont(ofSize: fontSize, weight: .regular)
            case 1:
                font = .systemFont(ofSize: fontSize, weight: .bold)
            case 2:
                font = .italicSystemFont(ofSize: fontSize)
            case 3:
                font = .systemFont(ofSize: fontSize, weight: .heavy)
            default:
                font = .systemFont(ofSize: fontSize, weight: .medium)
            }
            
            let textSize = word.size(withAttributes: [.font: font])
            let maxX = size.width - textSize.width - padding
            let maxY = size.height - textSize.height - padding
            
            var attempts = 0
            while attempts < 100 {
                let x = CGFloat.random(in: padding...maxX)
                let y = CGFloat.random(in: padding...maxY)
                let rect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                
                let expandedRect = rect.insetBy(dx: -padding, dy: -padding)
                let hasSignificantOverlap = occupiedRects.contains { existing in
                    let intersection = existing.intersection(expandedRect)
                    return intersection.width > textSize.width * 0.3 || intersection.height > textSize.height * 0.3
                }
                
                if !hasSignificantOverlap {
                    occupiedRects.append(expandedRect)
                    backgroundWords.append((
                        id: UUID(),
                        word: word,
                        position: CGPoint(x: x + textSize.width/2, y: y + textSize.height/2),
                        font: font,
                        opacity: Double.random(in: 0.1...0.2)
                    ))
                    break
                }
                
                attempts += 1
            }
        }
    }
}
