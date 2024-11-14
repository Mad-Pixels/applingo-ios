import SwiftUI

struct GameLettersView: View {
    @Binding var isPresented: Bool

    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameLettersContent()
        }
    }
}

import SwiftUI

private struct GameLettersContent: View {
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel

    @State private var currentWord: WordItemModel?
    @State private var scrambledLetters: [Character] = []
    @State private var selectedLetters: [Character] = []
    @State private var extraLetters: [Character] = []
    @State private var showAnswerFeedback = false
    @State private var showSuccessEffect = false
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
    @State private var alphabetLetters: [Character] = []

    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else {
                VStack(spacing: 20) {
                    if let word = currentWord {
                        Text(word.frontText)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()

                        // Поле для выбранных букв
                        LetterGridView(letters: selectedLetters, onTap: removeLetter)

                        // Кнопка подсказки
                        Button(action: {
                            useHint()
                        }) {
                            Image(systemName: "lightbulb.fill")
                                .font(.largeTitle)
                                .foregroundColor(hintState.wasUsed ? .yellow : .gray)
                        }

                        // Поле с перемешанными буквами
                        LetterGridView(letters: scrambledLetters, onTap: addLetter)

                        Spacer()
                    }
                }
                .padding()
                if showAnswerFeedback {
                    answerFeedbackView.zIndex(1)
                }
            }
        }
        .onAppear { setupGame() }
        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
            if !isLoading { setupGame() }
        }
    }

    private var answerFeedbackView: some View {
        VStack {
            if gameAction.stats.isLastAnswerCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 60))
            } else {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 60))
            }
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

        currentWord = word
        hintState = GameHintState(isShowing: false, wasUsed: false)
        selectedLetters = []
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0

        // Получаем буквы из backText
        var letters = Array(word.backText)
        // Получаем алфавит слова
        alphabetLetters = getAlphabetLetters(for: word.backText)

        // Добавляем дополнительные буквы
        let extraLettersCount = min(3, alphabetLetters.count)
        extraLetters = getExtraLetters(exclude: letters, count: extraLettersCount)

        letters += extraLetters
        scrambledLetters = letters.shuffled()
    }

    private func addLetter(_ letter: Character) {
        if let index = scrambledLetters.firstIndex(of: letter) {
            scrambledLetters.remove(at: index)
            selectedLetters.append(letter)
            checkAnswer()
        }
    }

    private func removeLetter(_ letter: Character) {
        if let index = selectedLetters.firstIndex(of: letter) {
            selectedLetters.remove(at: index)
            scrambledLetters.append(letter)
            scrambledLetters.shuffle()
        }
    }

    private func checkAnswer() {
        guard let word = currentWord else { return }
        let userAnswer = String(selectedLetters)
        if userAnswer.count == word.backText.count {
            let isCorrect = userAnswer.lowercased() == word.backText.lowercased()
            handleResult(isCorrect: isCorrect)
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
            cacheGetter.removeFromCache(word)
        } else {
            FeedbackWrongAnswerHaptic().playHaptic()
        }

        withAnimation {
            showAnswerFeedback = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showAnswerFeedback = false
            }
            generateNewWord()
        }
    }

    private func useHint() {
        if !hintState.wasUsed {
            hintState.isShowing = true
            hintState.wasUsed = true
            hintPenalty = 5
            // Открываем первую букву
            if let firstLetter = currentWord?.backText.first {
                if !selectedLetters.contains(firstLetter) {
                    addLetter(firstLetter)
                }
            }
        }
    }

    private func getAlphabetLetters(for text: String) -> [Character] {
        let letters = Set(text.lowercased())
        var alphabetSet = Set<Character>()
        for scalar in letters.map({ $0.unicodeScalars.first! }) {
            if CharacterSet.lowercaseLetters.contains(scalar) {
                alphabetSet.formUnion(CharacterSet.lowercaseLetters.characters)
            } else if CharacterSet.uppercaseLetters.contains(scalar) {
                alphabetSet.formUnion(CharacterSet.uppercaseLetters.characters)
            } else if CharacterSet(charactersIn: "\u{0590}"..."\u{05FF}").contains(scalar) {
                // Hebrew
                alphabetSet.formUnion(CharacterSet(charactersIn: "\u{0590}"..."\u{05FF}").characters)
            } else {
                // Add other character sets as needed
                alphabetSet.formUnion([Character(scalar)])
            }
        }
        return Array(alphabetSet)
    }

    private func getExtraLetters(exclude: [Character], count: Int) -> [Character] {
        let availableLetters = alphabetLetters.filter { !exclude.contains($0) }
        return Array(availableLetters.shuffled().prefix(count))
    }
}

import SwiftUI

struct LetterGridView: View {
    let letters: [Character]
    let onTap: (Character) -> Void

    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 44), spacing: 10)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(letters, id: \.self) { letter in
                Text(String(letter))
                    .font(.title)
                    .frame(width: 44, height: 44)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onTapGesture {
                        onTap(letter)
                    }
            }
        }
    }
}

private func getAlphabetLetters(for text: String) -> [Character] {
    var characterSet: CharacterSet?

    if text.range(of: "\\p{Hebrew}", options: .regularExpression) != nil {
        // Hebrew
        characterSet = CharacterSet(charactersIn: "\u{0590}"..."\u{05FF}")
    } else if text.range(of: "\\p{Cyrillic}", options: .regularExpression) != nil {
        // Cyrillic
        characterSet = CharacterSet(charactersIn: "\u{0400}"..."\u{04FF}")
    } else if text.range(of: "\\p{Latin}", options: .regularExpression) != nil {
        // Latin
        characterSet = CharacterSet.lowercaseLetters.union(.uppercaseLetters)
    } else {
        // Default to letters
        characterSet = CharacterSet.letters
    }

    if let characterSet = characterSet {
        return characterSet.characters
    } else {
        return []
    }
}


extension CharacterSet {
    var characters: [Character] {
        var chars: [Character] = []
        for plane: UInt8 in 0...16 {
            if self.hasMember(inPlane: plane) {
                for codePoint in UInt32(plane) << 16 ..< (UInt32(plane + 1) << 16) {
                    if let scalar = UnicodeScalar(codePoint), self.contains(scalar) {
                        chars.append(Character(scalar))
                    }
                }
            }
        }
        return chars
    }
}
