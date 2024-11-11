import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

struct BaseGameView<Content: View>: View {
    @StateObject private var viewModel: GameViewModel
        @State private var gameMode: GameMode = .practice
        @State private var gameStats = GameStats()
        @State private var isGameActive = false
        @State private var timer: Timer?
    @StateObject private var gameHandler: GameHandler
        
        let isPresented: Binding<Bool>
        let content: Content
        let minimumWordsRequired: Int
    
    init(
        isPresented: Binding<Bool>,
        minimumWordsRequired: Int = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.isPresented = isPresented
        self.minimumWordsRequired = minimumWordsRequired
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let repository = RepositoryWord(dbQueue: dbQueue)
        self._viewModel = StateObject(wrappedValue: GameViewModel(repository: repository))
        
        self._gameHandler = StateObject(wrappedValue: GameHandler(
                    mode: .practice,
                    stats: GameStats(),
                    onGameEnd: {
                        // Обработка окончания игры
                    }
                ))
        
        self.content = content()
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                
                HStack {
                                    if isGameActive {
                                        GameToolbar(
                                            gameMode: gameMode,
                                            stats: gameStats,
                                            isGameActive: $isGameActive
                                        )
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.clearCache()
                                        isPresented.wrappedValue = false
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(theme.baseTextColor)
                                    }
                                }
                                .padding()
                
                if viewModel.isLoadingCache {
                                    Spacer()
                                    CompPreloaderView()
                                    Spacer()
                                } else if viewModel.cache.count < minimumWordsRequired {
                                    Spacer()
                                    CompGameStateView()
                                    Spacer()
                                } else if !isGameActive {
                                    Spacer()
                                    GameModeSelectionView(
                                        selectedMode: $gameMode,
                                        startGame: startGame
                                    )
                                    Spacer()
                                } else {
                                    Spacer()
                                    content
                                        .environmentObject(viewModel)
                                        .environmentObject(gameHandler)  // Добавляем GameHandler
                                    Spacer()
                                }
            }
        }
        .onAppear {
            FrameManager.shared.setActiveFrame(.game)
            viewModel.setFrame(.game)
            viewModel.initializeCache()
            setupGame()
        }
        .onDisappear {
            viewModel.clearCache()
            endGame()
        }
    }
    
    private func setupGame() {
            FrameManager.shared.setActiveFrame(.game)
            viewModel.setFrame(.game)
            viewModel.initializeCache()
        }
    
    private func startGame() {
        gameStats = GameStats()
        isGameActive = true
        
        // Обновляем GameHandler при старте игры
        gameHandler.stats = gameStats
        gameHandler.mode = gameMode
        gameHandler.onGameEnd = endGame
        
        switch gameMode {
        case .timeAttack:
            startTimer()
        case .survival:
            gameStats.lives = 3
        default:
            break
        }
    }
    
    private func endGame() {
            isGameActive = false
            timer?.invalidate()
            timer = nil
            viewModel.clearCache()
        }
    
    private func startTimer() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if gameStats.timeRemaining > 0 {
                    gameStats.timeRemaining -= 1
                } else {
                    endGame()
                    // Показать результаты
                }
            }
        }
    
    func handleGameResult(_ result: GameResult) {
            let startTime = Date().timeIntervalSince1970
            gameStats.updateStats(
                isCorrect: result.isCorrect,
                responseTime: startTime
            )
            
            // Проверка условий окончания игры
            switch gameMode {
            case .survival where gameStats.lives <= 0:
                endGame()
                // Показать результаты
            default:
                break
            }
        }
}


enum GameMode {
    case practice  // Бесконечная практика
    case survival  // 3 жизни
    case timeAttack  // Ограниченное время (например, 2 минуты)
}


struct GameStats {
    var score: Int = 0
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var streak: Int = 0
    var bestStreak: Int = 0
    var lives: Int = 3  // Для режима Survival
    var timeRemaining: TimeInterval = 120  // Для режима TimeAttack (в секундах)
    var averageResponseTime: TimeInterval = 0
    
    mutating func updateStats(isCorrect: Bool, responseTime: TimeInterval) {
        if isCorrect {
            correctAnswers += 1
            streak += 1
            bestStreak = max(bestStreak, streak)
            // Бонус за скорость ответа
            let timeBonus = max(5 * (1.0 - responseTime/3.0), 1)
            // Бонус за серию
            let streakMultiplier = min(Double(streak) * 0.1 + 1.0, 2.0)
            score += Int(Double(10 + Int(timeBonus)) * streakMultiplier)
        } else {
            wrongAnswers += 1
            streak = 0
            lives -= 1
        }
        
        let totalAnswers = correctAnswers + wrongAnswers
        averageResponseTime = (averageResponseTime * Double(totalAnswers - 1) + responseTime) / Double(totalAnswers)
    }
}

protocol GameResult {
    var wordId: Int { get }
    var isCorrect: Bool { get }
    var responseTime: TimeInterval { get }
}

struct GameToolbar: View {
    let gameMode: GameMode
    let stats: GameStats
    @Binding var isGameActive: Bool
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        HStack {
            // Режим игры и переключатель
            Menu {
                Button("Practice") { /* switch mode */ }
                Button("Survival") { /* switch mode */ }
                Button("Time Attack") { /* switch mode */ }
            } label: {
                HStack {
                    Image(systemName: modeIcon)
                    Text(modeTitle)
                }
                .foregroundColor(theme.baseTextColor)
            }
            
            Divider()
                .background(theme.accentColor)
                .frame(height: 20)
            
            // Статистика в зависимости от режима
            Group {
                switch gameMode {
                case .practice:
                    HStack {
                        Image(systemName: "star.fill")
                        Text("\(stats.score)")
                        Text("Streak: \(stats.streak)")
                    }
                case .survival:
                    HStack {
                        ForEach(0..<3) { index in
                            Image(systemName: index < stats.lives ? "heart.fill" : "heart")
                                .foregroundColor(index < stats.lives ? .red : theme.secondaryTextColor)
                        }
                        Text("\(stats.score)")
                    }
                case .timeAttack:
                    HStack {
                        Image(systemName: "clock")
                        Text(timeString)
                        Text("\(stats.score)")
                    }
                }
            }
            .foregroundColor(theme.baseTextColor)
            
            Spacer()
            
            // Accuracy
            Text("\(Int((Double(stats.correctAnswers) / Double(max(stats.correctAnswers + stats.wrongAnswers, 1))) * 100))%")
                .foregroundColor(theme.secondaryTextColor)
        }
        .padding()
        .background(theme.backgroundBlockColor.opacity(0.3))
    }
    
    private var modeIcon: String {
        switch gameMode {
        case .practice: return "book.fill"
        case .survival: return "heart.fill"
        case .timeAttack: return "clock.fill"
        }
    }
    
    private var modeTitle: String {
        switch gameMode {
        case .practice: return "Practice"
        case .survival: return "Survival"
        case .timeAttack: return "Time Attack"
        }
    }
    
    private var timeString: String {
        let minutes = Int(stats.timeRemaining) / 60
        let seconds = Int(stats.timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}





struct GameModeSelectionView: View {
    @Binding var selectedMode: GameMode
    let startGame: () -> Void
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(spacing: 20) {
            Text("Select Game Mode")
                .font(.title)
                .foregroundColor(theme.baseTextColor)
            
            VStack(spacing: 16) {
                GameModeButton(
                    title: "Practice",
                    icon: "book.fill",
                    description: "Practice without limits",
                    action: {
                        selectedMode = .practice
                        startGame()
                    }
                )
                
                GameModeButton(
                    title: "Survival",
                    icon: "heart.fill",
                    description: "3 lives, how far can you go?",
                    action: {
                        selectedMode = .survival
                        startGame()
                    }
                )
                
                GameModeButton(
                    title: "Time Attack",
                    icon: "clock.fill",
                    description: "Race against time!",
                    action: {
                        selectedMode = .timeAttack
                        startGame()
                    }
                )
            }
        }
        .padding()
    }
}

struct GameModeButton: View {
    let title: String
    let icon: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(theme.secondaryTextColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.secondaryTextColor)
            }
            .padding()
            .background(theme.backgroundBlockColor.opacity(0.3))
            .cornerRadius(10)
        }
        .foregroundColor(theme.baseTextColor)
    }
}


class GameHandler: ObservableObject {
    @Published var stats: GameStats
    var mode: GameMode
    var onGameEnd: (() -> Void)?
    
    init(mode: GameMode, stats: GameStats, onGameEnd: (() -> Void)? = nil) {
        self.mode = mode
        self.stats = stats
        self.onGameEnd = onGameEnd
    }
    
    func handleGameResult(_ result: GameResult) {
        stats.updateStats(
            isCorrect: result.isCorrect,
            responseTime: result.responseTime
        )
        
        // Проверяем условия окончания игры
        switch mode {
        case .survival where stats.lives <= 0:
            onGameEnd?()
        case .timeAttack where stats.timeRemaining <= 0:
            onGameEnd?()
        default:
            break
        }
    }
}

