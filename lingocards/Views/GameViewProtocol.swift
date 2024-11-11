import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

struct BaseGameView<Content: View>: View {
    @StateObject private var viewModel: GameViewModel
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
        self.content = content()
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack {
            theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.clearCache()
                        isPresented.wrappedValue = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(theme.baseTextColor)
                    }
                    .padding()
                }
                if viewModel.isLoadingCache {
                    Spacer()
                    CompPreloaderView()
                    Spacer()
                } else if viewModel.cache.count < minimumWordsRequired {
                    Spacer()
                    CompGameStateView()
                    Spacer()
                } else {
                    content.environmentObject(viewModel)
                }
            }
        }
        .onAppear {
            FrameManager.shared.setActiveFrame(.game)
            viewModel.setFrame(.game)
            viewModel.initializeCache()
        }
        .onDisappear {
            viewModel.clearCache()
        }
    }
}
