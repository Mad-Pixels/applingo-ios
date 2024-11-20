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
                CompGameLetterContentSections.WordSection(word: word, style: style)
            }
            Spacer(minLength: 20)
            
            CompGameLetterContentSections.AnswerSection(
                selectedLetters: selectedLetters,
                onTap: removeLetter,
                style: style
            )
            
            CompGameLetterContentSections.HintSection(
                hint: "",
                hintState: hintState,
                style: style,
                onTap: useHint
            )
            Spacer(minLength: 20)
            
            CompGameLetterGridView(
                letters: scrambledLetters,
                onTap: addLetter,
                style: .option,
                cardStyle: style
            )
            .padding(.horizontal)
        }
        .padding()
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
        
        resetState()
        setupNewWord(word)
    }
    
    private func resetState() {
        hintState = GameHintState(isShowing: false, wasUsed: false)
        selectedLetters = []
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0
    }
    
    private func setupNewWord(_ word: WordItemModel) {
        let targetWord = word.backText.lowercased()
        var letters = Array(targetWord)
        
        if let extraLetters = generateExtraLetters(for: targetWord) {
            letters.append(contentsOf: extraLetters)
        }
        
        scrambledLetters = letters.shuffled()
        currentWord = word
    }
    
    private func generateExtraLetters(for word: String) -> [Character]? {
        let extraCount = min(max(3, word.count / 3), 5)
        guard let script = ScriptType.detect(from: word) else { return nil }
        
        let characters = script.getCharacters()
        let wordLower = word.lowercased()
        let availableChars = characters.filter { !wordLower.contains(String($0).lowercased()) }
        
        guard availableChars.count >= extraCount else { return nil }
        return Array(availableChars.shuffled().prefix(extraCount))
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
        
        let result = createGameResult(word: word, isCorrect: isCorrect)
        gameAction.handleGameResult(result)
        
        playFeedback(isCorrect: isCorrect)
        if isCorrect {
            cacheGetter.removeFromCache(word)
        }
        
        showFeedbackAndGenerateNewWord()
    }
    
    private func createGameResult(word: WordItemModel, isCorrect: Bool) -> GameVerifyResultModel {
        GameVerifyResultModel(
            word: word,
            isCorrect: isCorrect,
            responseTime: Date().timeIntervalSince1970 - startTime,
            isSpecial: gameAction.isSpecial(word),
            hintPenalty: hintPenalty
        )
    }
    
    private func playFeedback(isCorrect: Bool) {
        if !isCorrect {
            FeedbackWrongAnswerHaptic().playHaptic()
        }
    }
    
    private func showFeedbackAndGenerateNewWord() {
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
        handleHintPenalty()
        applyHint()
    }
    
    private func handleHintPenalty() {
        withAnimation(.spring()) {
            if !hintState.wasUsed {
                hintState.wasUsed = true
                hintState.isShowing = true
                hintPenalty = 5
            } else {
                hintPenalty += 2
            }
        }
    }
    
    private func applyHint() {
        guard let word = currentWord else { return }
        
        let correctWord = word.backText.lowercased()
        let currentAnswer = String(selectedLetters).lowercased()
        let correctIndex = findFirstMismatchIndex(current: currentAnswer, correct: correctWord)
        
        if correctIndex < correctWord.count {
            applyCorrection(at: correctIndex, in: correctWord)
        }
    }
    
    private func findFirstMismatchIndex(current: String, correct: String) -> Int {
        for (index, letter) in current.enumerated() {
            let correctLetter = Array(correct)[index]
            if letter != correctLetter {
                return index
            }
        }
        return current.count
    }
    
    private func applyCorrection(at index: Int, in correctWord: String) {
        let correctLetter = Array(correctWord)[index]
        
        if index < selectedLetters.count {
            let currentLetter = selectedLetters[index]
            removeLetter(currentLetter)
        }
        
        if let correctLetterIndex = scrambledLetters.firstIndex(where: {
            String($0).lowercased() == String(correctLetter)
        }) {
            addLetter(scrambledLetters[correctLetterIndex])
        }
    }
}
