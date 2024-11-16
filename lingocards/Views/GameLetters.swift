import SwiftUI

struct GameLettersView: View {
    @Binding var isPresented: Bool

    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameLettersContent()
        }
    }
}

private struct GameLettersContent: View {
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel
    
    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
    @State private var currentWord: WordItemModel?
    @State private var scrambledLetters: [Character] = []
    @State private var selectedLetters: [Character] = []
    @State private var showAnswerFeedback = false
    @State private var showSuccessEffect = false
    @State private var isAnswerCorrect = false
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else {
                gameContent
                if showAnswerFeedback {
                    AnswerFeedback(
                        isCorrect: isAnswerCorrect,
                        isSpecial: currentWord.map(gameAction.isSpecial) ?? false
                    )
                    .zIndex(1)
                }
            }
        }
        .onAppear { setupGame() }
        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
            if !isLoading { setupGame() }
        }
    }
    
    private var gameContent: some View {
        VStack(spacing: 24) {
            if let word = currentWord {
                wordSection(word)
            }
            Spacer(minLength: 20)
            answerSection
            
            if let hint = currentWord?.hint {
                hintSection(hint)
            }
            Spacer(minLength: 20)
            lettersSection
        }
        .padding()
    }
    
    private func wordSection(_ word: WordItemModel) -> some View {
        VStack(spacing: 12) {
            Text(LanguageManager.shared.localizedString(for: "ComposeTheTranslation").capitalizedFirstLetter)
                .font(GameCardStyle.Typography.captionFont)
                .foregroundColor(style.theme.secondaryTextColor)
            Text(word.frontText)
                .font(GameCardStyle.Typography.mainTextFont)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(style.theme.backgroundBlockColor)
                        .shadow(
                            color: style.theme.accentColor.opacity(0.1),
                            radius: 5,
                            x: 0,
                            y: 2
                        )
                )
        }
    }
    
    private var answerSection: some View {
        VStack(spacing: 16) {
            LetterGridView(
                letters: selectedLetters,
                onTap: removeLetter,
                style: .answer
            )
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style.theme.accentColor.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    private var lettersSection: some View {
        LetterGridView(
            letters: scrambledLetters,
            onTap: addLetter,
            style: .option
        )
        .padding(.horizontal)
    }
    
    private func hintSection(_ hint: String) -> some View {
        VStack {
            if hintState.isShowing {
                style.hintContainer {
                    style.hintPenalty()
                    
                    Text(hint)
                        .font(GameCardStyle.Typography.hintFont)
                        .foregroundColor(style.theme.secondaryTextColor)
                        .multilineTextAlignment(.center)
                }
            }
            Button(action: useHint) {
                style.hintButton(isActive: hintState.isShowing)
            }
            .disabled(hintState.wasUsed && hintState.isShowing)
        }
    }
    
    private func setupGame() {
        let special = SpecialGoldCard(
            config: .standard,
            showSuccessEffect: $showSuccessEffect
        )
        gameAction.registerSpecial(special)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            generateNewWord()
        }
    }
        
    private func generateNewWord() {
        guard let word = cacheGetter.cache.randomElement() else { return }
            
        hintState = GameHintState(isShowing: false, wasUsed: false)
        selectedLetters = []
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0
            
        let targetWord = word.backText.lowercased()
        var letters = Array(targetWord)
            
        let extraCount = min(max(3, targetWord.count / 3), 5)
        if let extraLetters = generateExtraLetters(for: targetWord, count: extraCount) {
            letters.append(contentsOf: extraLetters)
        }
        scrambledLetters = letters.shuffled()
        currentWord = word
    }
        
    private func generateExtraLetters(for word: String, count: Int) -> [Character]? {
        guard let script = ScriptType.detect(from: word) else { return nil }
        
        let characters = script.getCharacters()
        let wordLower = word.lowercased()
        let availableChars = characters.filter { !wordLower.contains(String($0).lowercased()) }
        
        guard availableChars.count >= count else { return nil }
        return Array(availableChars.shuffled().prefix(count))
    }
        
    private func addLetter(_ letter: Character) {
        guard let index = scrambledLetters.firstIndex(of: letter) else { return }
            
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            scrambledLetters.remove(at: index)
            selectedLetters.append(letter)
        }
        checkAnswer()
    }
        
    private func removeLetter(_ letter: Character) {
        guard let index = selectedLetters.firstIndex(of: letter) else { return }
            
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedLetters.remove(at: index)
            scrambledLetters.append(letter)
            scrambledLetters.shuffle()
        }
    }

    private func checkAnswer() {
        guard let word = currentWord else { return }
        let userAnswer = String(selectedLetters).lowercased()
        let correctAnswer = word.backText.lowercased()
            
        if userAnswer.count == correctAnswer.count {
            isAnswerCorrect = userAnswer == correctAnswer
            handleResult(isCorrect: isAnswerCorrect)
        }
    }
        
    private func handleResult(isCorrect: Bool) {
        guard let word = currentWord else { return }
            
        let responseTime = Date().timeIntervalSince1970 - startTime
        let result = GameVerifyResultModel(
            word: word,
            isCorrect: isCorrect,
            responseTime: responseTime,
            isSpecial: gameAction.isSpecial(word),
            hintPenalty: hintPenalty
        )
        gameAction.handleGameResult(result)
            
        if isCorrect {
            FeedbackCorrectAnswerHaptic().playHaptic()
            cacheGetter.removeFromCache(word)
        } else {
            FeedbackWrongAnswerHaptic().playHaptic()
        }
            
        withAnimation(.easeInOut(duration: 0.3)) {
            showAnswerFeedback = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                showAnswerFeedback = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    generateNewWord()
                }
            }
        }
    }
        
    private func useHint() {
        if !hintState.wasUsed {
            withAnimation(.spring()) {
                hintState.wasUsed = true
                hintState.isShowing = true
                hintPenalty = 5
            }
            if let firstLetter = currentWord?.backText.first?.lowercased() {
                let firstChar = Character(String(firstLetter))
                if !selectedLetters.contains(firstChar),
                   let index = scrambledLetters.firstIndex(where: { $0.lowercased() == String(firstChar).lowercased() }) {
                        addLetter(scrambledLetters[index])
                    }
                }
        } else {
            withAnimation(.spring()) {
                hintState.isShowing.toggle()
            }
        }
    }
}


// MARK: - Letter Grid Components
struct LetterGridView: View {
    let letters: [Character]
    let onTap: (Character) -> Void
    let style: LetterStyle
    
    private let columns = [
        GridItem(.adaptive(minimum: 50), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(letters, id: \.self) { letter in
                LetterButton(letter: letter, style: style, onTap: onTap)
            }
        }
        .padding(8)
    }
    
    enum LetterStyle {
        case option
        case answer
    }
}

struct LetterButton: View {
    let letter: Character
    let style: LetterGridView.LetterStyle
    let onTap: (Character) -> Void
    
    var body: some View {
        Button(action: { onTap(letter) }) {
            Text(String(letter))
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .frame(width: 50, height: 50)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: shadowColor, radius: 2, x: 0, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var backgroundColor: Color {
        switch style {
        case .option:
            return Color(.systemGray6)
        case .answer:
            return Color(.systemBackground)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .option:
            return Color(.label)
        case .answer:
            return .accentColor
        }
    }
    
    private var shadowColor: Color {
        Color(.systemGray).opacity(0.2)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


private enum ScriptType {
    case hebrew
    case cyrillic
    case latin
    case devanagari
    case arabic
    case thai
    case japanese
    case korean
    
    var range: ClosedRange<UInt32> {
        switch self {
        case .hebrew:     return 0x05D0...0x05EA   // Только основные буквы иврита
        case .cyrillic:   return 0x0430...0x044F   // Только строчные кириллические буквы
        case .latin:      return 0x0061...0x007A   // Basic Latin lowercase
        case .devanagari: return 0x0900...0x097F   // Devanagari
        case .arabic:     return 0x0600...0x06FF   // Arabic
        case .thai:       return 0x0E00...0x0E7F   // Thai
        case .japanese:   return 0x3040...0x309F   // Hiragana
        case .korean:     return 0xAC00...0xD7AF   // Hangul
        }
    }
    
    // Дополнительные диапазоны для проверки валидности
    var excludedRanges: [ClosedRange<UInt32>] {
        switch self {
        case .hebrew:
            // Исключаем никуды и специальные символы
            return [0x0591...0x05C7, 0x05EB...0x05EF]
        case .cyrillic:
            // Исключаем специальные символы
            return [0x0450...0x045F]
        default:
            return []
        }
    }
    
    static func detect(from text: String) -> ScriptType? {
        guard let firstChar = text.unicodeScalars.first else { return nil }
        let value = firstChar.value
        
        for script in [
            ScriptType.hebrew,
            ScriptType.cyrillic,
            ScriptType.latin,
            ScriptType.devanagari,
            ScriptType.arabic,
            ScriptType.thai,
            ScriptType.japanese,
            ScriptType.korean
        ] {
            if (script.range.lowerBound...script.range.upperBound).contains(value) {
                return script
            }
        }
        
        return nil
    }
    
    func getCharacters() -> [Character] {
        var characters: [Character] = []
        
        for value in range {
            // Пропускаем значения из исключенных диапазонов
            if excludedRanges.contains(where: { $0.contains(value) }) {
                continue
            }
            
            // Проверяем возможность создания и отображения символа
            guard let scalar = UnicodeScalar(value),
                  let char = Character(String(scalar)).validForDisplay() else {
                continue
            }
            
            characters.append(char)
        }
        
        return characters
    }
}


extension Character {
    func validForDisplay() -> Character? {
        let string = String(self)
        
        // Проверяем, что строка не является пустой
        guard !string.isEmpty else { return nil }
        
        // Проверяем, что все `unicodeScalars` в строке не содержат управляющих символов и пробелов
        for scalar in string.unicodeScalars {
            if CharacterSet.whitespacesAndNewlines.contains(scalar) || CharacterSet.controlCharacters.contains(scalar) {
                return nil
            }
        }
        
        // Проверяем, что символ не отображается как пустой квадрат (используем для проверки строки)
        guard string != "�" else { return nil }
        
        // Дополнительная проверка на корректность отображения
        let scalars = string.unicodeScalars
        guard scalars.allSatisfy({ !CharacterSet.nonBaseCharacters.contains($0) }) else {
            return nil
        }
        
        return self
    }
}

extension CharacterSet {
    static let nonBaseCharacters: CharacterSet = {
        var set = CharacterSet.controlCharacters
        set.formUnion(.illegalCharacters)
        set.formUnion(CharacterSet(charactersIn: "\u{0300}"..."\u{036F}")) // Диакритические знаки
        return set
    }()
}
