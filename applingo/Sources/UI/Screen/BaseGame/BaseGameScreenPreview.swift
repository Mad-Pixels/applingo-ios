//import SwiftUI
//
//#if DEBUG
//// Game Protocol Mock
//private class MockGame: GameProtocol {
//    var type: GameType = .quiz
//    var minimumWordsRequired: Int = 10
//    var availableModes: [GameModeEnum] = [.practice, .survival, .timeAttack]
//    var isReadyToPlay: Bool
//    
//    init(isReadyToPlay: Bool = true) {
//        self.isReadyToPlay = isReadyToPlay
//    }
//    
//    func start(mode: GameModeEnum) {}
//    func end() {}
//}
//
//// Preview struct
//struct BaseGameScreenPreview: View {
//    let theme: ThemeType
//    let game: GameProtocol
//    let style: BaseGameScreenStyle
//    
//    init(
//        theme: ThemeType = .light,
//        game: GameProtocol = MockGame(),
//        style: BaseGameScreenStyle = .default
//    ) {
//        self.theme = theme
//        self.game = game
//        self.style = style
//        
//        ThemeManager.shared.setTheme(to: theme)
//    }
//    
//    var body: some View {
//        BaseGameScreen(
//            game: game,
//            style: style
//        ) {
//            Text("Game Content")
//                .font(.title)
//                .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
//        }
//        .environmentObject(ThemeManager.shared)
//        .environmentObject(LocaleManager.shared)
//        .preferredColorScheme(theme == .dark ? .dark : .light)
//    }
//}
//
//#Preview("Light Theme - Ready to Play") {
//    BaseGameScreenPreview(theme: .light)
//}
//
//#Preview("Dark Theme - Ready to Play") {
//    BaseGameScreenPreview(theme: .dark)
//}
//
//#Preview("Not Ready to Play") {
//    BaseGameScreenPreview(
//        theme: .light,
//        game: MockGame(isReadyToPlay: false)
//    )
//}
//
//#Preview("Custom Style") {
//    BaseGameScreenPreview(
//        theme: .light,
//        style: BaseGameScreenStyle(
//            baseStyle: BaseScreenStyle(
//                uiKit: BaseScreenStyle.UIKitStyle(
//                    backgroundColor: { theme in
//                        theme.backgroundSecondary
//                    }
//                )
//            )
//        )
//    )
//}
//#endif
