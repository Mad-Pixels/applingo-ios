import SwiftUI

import SwiftUI

struct GameModeView: View {
    @Binding var selectedMode: GameMode
    let startGame: () -> Void
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(spacing: 20) {            
            Text(LanguageManager.shared.displayName(for: "SelectGameMode").uppercased())
                .font(.title)
                .foregroundColor(theme.baseTextColor)
            
            VStack(spacing: 16) {
                CompButtonGameModeView(
                    title: LanguageManager.shared.displayName(
                        for: "Practice"
                    ).capitalizedFirstLetter,
                    icon: "book.fill",
                    description: LanguageManager.shared.displayName(
                        for: "PracticeDescription"
                    ),
                    action: {
                        selectedMode = .practice
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            startGame()
                        }
                    }
                )
                CompButtonGameModeView(
                    title: LanguageManager.shared.displayName(
                        for: "Survival"
                    ).capitalizedFirstLetter,
                    icon: "heart.fill",
                    description: LanguageManager.shared.displayName(
                        for: "SurvivalDescription"
                    ),
                    action: {
                        selectedMode = .survival
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            startGame()
                        }
                    }
                )
                CompButtonGameModeView(
                    title: LanguageManager.shared.displayName(
                        for: "TimeAttack"
                    ).capitalizedFirstLetter,
                    icon: "clock.fill",
                    description: LanguageManager.shared.displayName(
                        for: "TimeAttackDescription"
                    ),
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
