import SwiftUI

struct CompBackgroundWordsView: View {
    @State private var backgroundWords: [
        (id: UUID, word: String, position: CGPoint, font: UIFont, opacity: Double)
    ] = []
    
    private let languages = [
        "HELLO", "BONJOUR", "HOLA", "CIAO", "ПРИВЕТ", "HALLO", "你好", "こんにちは", "안녕하세요", "مرحبا", "שָׁלוֹם",
        "NAMASTE", "SAWADEE", "MERHABA", "OLÁ", "ЗДРАВЕЙТЕ", "ΓΕΙΑ ΣΑΣ", "JAMBO", "BONGU", "XIN CHÀO",
        "LEARN", "APPRENDRE", "APRENDER", "IMPARARE", "УЧИТЬ", "LERNEN", "学习", "学ぶ", "배우다", "تعلم", "לִלמוֹד",
        "SIKHNA", "RIAN", "ÖĞRENMEK", "ESTUDAR", "УЧА", "ΜΑΘΑΙΝΩ", "JIFUNZE", "TGĦALLEM", "HỌC",
        "WORLD", "MONDE", "MUNDO", "MONDO", "МИР", "WELT", "世界", "世界", "세계", "عالم", "עוֹלָם",
        "DUNIYA", "LOK", "DÜNYA", "MUNDO", "СВЯТ", "ΚΟΣΜΟΣ", "DUNIA", "DINJA", "THẾ GIỚI",
        "LANGUAGE", "LANGUE", "IDIOMA", "LINGUA", "ЯЗЫК", "SPRACHE", "语言", "言語", "언어", "لغة", "שָׂפָה",
        "BHASHA", "PHASA", "DIL", "LÍNGUA", "ЕЗИК", "ΓΛΩΣΣΑ", "LUGHA", "LINGWA", "NGÔN NGỮ",
        "BOOK", "LIVRE", "LIBRO", "LIBRO", "КНИГА", "BUCH", "书", "本", "책", "كتاب", "סֵפֶר",
        "KITAB", "NANGSUE", "KİTAP", "LIVRO", "КНИГА", "ΒΙΒΛΙΟ", "KITABU", "KTIEB", "SÁCH",
        "WRITE", "ÉCRIRE", "ESCRIBIR", "SCRIVERE", "ПИСАТЬ", "SCHREIBEN", "写", "書く", "쓰다", "يكتب", "לִכתוֹב",
        "LIKHNA", "KHIAN", "YAZMAK", "ESCREVER", "ПИША", "ΓΡΑΦΩ", "ANDIKA", "IKTEB", "VIẾT",
        "READ", "LIRE", "LEER", "LEGGERE", "ЧИТАТЬ", "LESEN", "读", "読む", "읽다", "يقرأ", "לִקרוֹא",
        "PADHNA", "AAN", "OKUMAK", "LER", "ЧЕТА", "ΔΙΑΒΑΖΩ", "SOMA", "AQRA", "ĐỌC",
        "SPEAK", "PARLER", "HABLAR", "PARLARE", "ГОВОРИТЬ", "SPRECHEN", "说话", "話す", "말하다", "يتكلم", "לְדַבֵּר",
        "BOLNA", "PHUT", "KONUŞMAK", "FALAR", "ГОВОРЯ", "ΜΙΛΑΩ", "SEMA", "TKELLEM", "NÓI",
        
        "STUDY", "ÉTUDIER", "ESTUDIAR", "STUDIARE", "УЧИТЬСЯ", "STUDIEREN", "学习", "勉強する", "공부하다", "يدرس", "לִלמוֹד",
        "ADHYAYAN", "SUKSA", "ÇALIŞMAK", "ESTUDAR", "УЧА СЕ", "ΣΠΟΥΔΑΖΩ", "SOMA", "STUDJA", "HỌC TẬP",
        
        "KNOWLEDGE", "CONNAISSANCE", "CONOCIMIENTO", "CONOSCENZA", "ЗНАНИЕ", "WISSEN", "知识", "知識", "지식", "معرفة", "יְדִיעָה",
        "GYAN", "KWAMROO", "BİLGİ", "CONHECIMENTO", "ЗНАНИЕ", "ΓΝΩΣΗ", "MAARIFA", "GĦARFIEN", "KIẾN THỨC",
        "WISDOM", "SAGESSE", "SABIDURÍA", "SAGGEZZA", "МУДРОСТЬ", "WEISHEIT", "智慧", "知恵", "지혜", "حكمة", "חָכמָה",
        "PRACTICE", "PRATIQUE", "PRÁCTICA", "PRATICA", "ПРАКТИКА", "PRAXIS", "实践", "練習", "연습", "ممارسة", "תַרגוּל",
        "MEMORY", "MÉMOIRE", "MEMORIA", "MEMORIA", "ПАМЯТЬ", "GEDÄCHTNIS", "记忆", "記憶", "기억", "ذاكرة", "זִכָּרוֹן",
        "TEACHER", "PROFESSEUR", "PROFESOR", "INSEGNANTE", "УЧИТЕЛЬ", "LEHRER", "老师", "先生", "선생님", "معلم", "מוֹרֶה",
        "STUDENT", "ÉTUDIANT", "ESTUDIANTE", "STUDENTE", "СТУДЕНТ", "STUDENT", "学生", "学生", "학생", "طالب", "תַלמִיד",
        "SUCCESS", "SUCCÈS", "ÉXITO", "SUCCESSO", "УСПЕХ", "ERFOLG", "成功", "成功", "성공", "نجاح", "הַצלָחָה",
        "FUTURE", "AVENIR", "FUTURO", "FUTURO", "БУДУЩЕЕ", "ZUKUNFT", "未来", "未来", "미래", "مستقبل", "עָתִיד",
        "DREAM", "RÊVE", "SUEÑO", "SOGNO", "МЕЧТА", "TRAUM", "梦想", "夢", "꿈", "حلم", "חֲלוֹם"
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
            .onChange(of: ThemeManager.shared.currentTheme) { _ in
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
                    return intersection.width > textSize.width * 0.3
                        || intersection.height > textSize.height * 0.3
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
