//import SwiftUI
//
//struct GameModeView: View {
//    @ObservedObject private var languageManager = LanguageManager.shared
//    @Binding var selectedMode: GameMode
//    let startGame: () -> Void
//    
//    @State private var selectedCard: GameMode?
//    @State private var isAnimating = false
//    
//    private let theme = ThemeManager.shared.currentThemeStyle
//    
//    var body: some View {
//        VStack(spacing: 32) {
//            Text(languageManager.localizedString(for: "SelectGameMode").uppercased())
//                .font(.system(.title, design: .rounded).weight(.bold))
//                .foregroundColor(theme.textPrimary)
//                .padding(.top)
//                .opacity(isAnimating ? 1 : 0)
//                .offset(y: isAnimating ? 0 : 20)
//            
//            VStack(spacing: 20) {
//                modeCard(
//                    mode: .practice,
//                    title: languageManager.localizedString(for: "GamePractice"),
//                    icon: "graduationcap.fill",
//                    description: languageManager.localizedString(for: "PracticeDescription"),
//                    color: theme.accentPrimary,
//                    delay: 0.1
//                )
//                
//                modeCard(
//                    mode: .survival,
//                    title: languageManager.localizedString(for: "GameSurvival"),
//                    icon: "heart.fill",
//                    description: languageManager.localizedString(for: "SurvivalDescription"),
//                    color: theme.accentPrimary,
//                    delay: 0.2
//                )
//                
//                modeCard(
//                    mode: .timeAttack,
//                    title: languageManager.localizedString(for: "GameTimeAttack"),
//                    icon: "timer",
//                    description: languageManager.localizedString(for: "TimeAttackDescription"),
//                    color: theme.accentPrimary,
//                    delay: 0.3
//                )
//            }
//            .padding(.horizontal)
//        }
//        .onAppear {
//            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                isAnimating = true
//            }
//        }
//    }
//    
//    private func modeCard(
//        mode: GameMode,
//        title: String,
//        icon: String,
//        description: String,
//        color: Color,
//        delay: Double
//    ) -> some View {
//        let isSelected = selectedCard == mode
//        
//        return Button(action: {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                selectedCard = mode
//            }
//            selectedMode = mode
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                startGame()
//            }
//        }) {
//            HStack(spacing: 20) {
//                Image(systemName: icon)
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 56, height: 56)
//                    .background(
//                        Circle()
//                            .fill(color)
//                    )
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(title.capitalizedFirstLetter)
//                        .font(.system(.headline, design: .rounded).weight(.bold))
//                        .foregroundColor(theme.textPrimary)
//                    
//                    Text(description.capitalizedFirstLetter)
//                        .font(.system(.body, design: .rounded))
//                        .foregroundColor(theme.textSecondary)
//                        .lineLimit(2)
//                }
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .font(.system(.body, weight: .semibold))
//                    .foregroundColor(theme.cardBorder)
//                    .opacity(isSelected ? 1 : 0.5)
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(theme.cardBorder)
//                    .shadow(
//                        color: color.opacity(0.2),
//                        radius: isSelected ? 10 : 5,
//                        x: 0,
//                        y: isSelected ? 5 : 2
//                    )
//            )
//            .scaleEffect(isSelected ? 1.02 : 1)
//            .opacity(isAnimating ? 1 : 0)
//            .offset(y: isAnimating ? 0 : 20)
//            .animation(
//                .spring(response: 0.6, dampingFraction: 0.8)
//                .delay(delay),
//                value: isAnimating
//            )
//        }
//    }
//}
