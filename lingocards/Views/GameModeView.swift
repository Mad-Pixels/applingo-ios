import SwiftUI

struct GameModeView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    
    @Binding var selectedMode: GameMode
    let startGame: () -> Void
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(spacing: 20) {            
            Text(languageManager.localizedString(for: "SelectGameMode").uppercased())
                .font(.title)
                .foregroundColor(theme.baseTextColor)
            
            VStack(spacing: 16) {
                CompButtonGameModeView(
                    title: languageManager.localizedString(
                        for: "GamePractice"
                    ).capitalizedFirstLetter,
                    icon: "book.fill",
                    description: languageManager.localizedString(
                        for: "PracticeDescription"
                    ).capitalizedFirstLetter,
                    action: {
                        selectedMode = .practice
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            startGame()
                        }
                    }
                )
                CompButtonGameModeView(
                    title: languageManager.localizedString(
                        for: "GameSurvival"
                    ).capitalizedFirstLetter,
                    icon: "heart.fill",
                    description: languageManager.localizedString(
                        for: "SurvivalDescription"
                    ).capitalizedFirstLetter,
                    action: {
                        selectedMode = .survival
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            startGame()
                        }
                    }
                )
                CompButtonGameModeView(
                    title: languageManager.localizedString(
                        for: "GameTimeAttack"
                    ).capitalizedFirstLetter,
                    icon: "clock.fill",
                    description: languageManager.localizedString(
                        for: "TimeAttackDescription"
                    ).capitalizedFirstLetter,
                    action: {
                        print("[GameModeView] Selecting TimeAttack mode")
                        selectedMode = .timeAttack
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            startGame()
                        }
                    }
                )
            }
        }
        .padding()
        .onChange(of: selectedMode) { newMode in
            print("[GameModeView] Mode changed to: \(newMode)")
        }
    }
}
