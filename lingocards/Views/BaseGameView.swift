import SwiftUI

struct BaseGameView<Content: View>: View {
    @StateObject private var cacheGetter: GameCacheGetterViewModel
    @StateObject private var gameAction: GameActionViewModel
    
    let isPresented: Binding<Bool>
    let content: Content
    let minimumWordsRequired: Int
    
    init(
        isPresented: Binding<Bool>,
        minimumWordsRequired: Int = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.minimumWordsRequired = minimumWordsRequired
        self.isPresented = isPresented
        self.content = content()
        
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let repository = RepositoryWord(dbQueue: dbQueue)
        self._cacheGetter = StateObject(wrappedValue: GameCacheGetterViewModel(repository: repository))
        self._gameAction = StateObject(wrappedValue: GameActionViewModel(repository: repository))
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack(alignment: .top) {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    if gameAction.isGameActive {
                        CompToolbarGame(
                            gameMode: gameAction.gameMode,
                            stats: gameAction.stats,
                            isGameActive: .constant(true)
                        )
                    }
                    Spacer()
                    Button(action: {
                        cacheGetter.clearCache()
                        gameAction.endGame()
                        isPresented.wrappedValue = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(theme.secondaryIconColor)
                    }
                }
                .padding()
                
                if cacheGetter.isLoadingCache {
                    Spacer()
                    CompPreloaderView()
                    Spacer()
                } else if cacheGetter.cache.count < minimumWordsRequired {
                    Spacer()
                    CompGameStateView()
                    Spacer()
                } else if !gameAction.isGameActive {
                    Spacer()
                    GameModeView(
                        selectedMode: .init(
                            get: { gameAction.gameMode },
                            set: { newMode in
                                gameAction.setGameMode(newMode)
                            }
                        ),
                        startGame: { gameAction.startGame() }
                    )
                    Spacer()
                } else {
                    Spacer()
                    content
                        .environmentObject(cacheGetter)
                        .environmentObject(gameAction)
                    Spacer()
                }
            }
        }
        .onAppear {
            FrameManager.shared.setActiveFrame(.game)
            cacheGetter.setFrame(.game)
            gameAction.setFrame(.game)
            cacheGetter.initializeCache()
        }
        .onDisappear {
            cacheGetter.clearCache()
            gameAction.endGame()
        }
    }
}
