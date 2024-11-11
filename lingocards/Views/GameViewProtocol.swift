import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

struct BaseGameView<Content: View>: View {
    @StateObject private var viewModel: GameViewModel
    let isPresented: Binding<Bool>
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let repository = RepositoryWord(dbQueue: dbQueue)
        self._viewModel = StateObject(wrappedValue: GameViewModel(repository: repository))
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            ThemeManager.shared.currentThemeStyle.backgroundViewColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.clearCache()
                        isPresented.wrappedValue = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
                    }
                    .padding()
                }
                
                content
                    .environmentObject(viewModel)
                
                Spacer()
            }
            .environmentObject(viewModel)
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
