import SwiftUI

struct ScreenGameMode: View {
   @StateObject private var style: GameModeStyle
   private let locale: GameModeLocale
   
   @Binding var selectedMode: GameMode
   let startGame: () -> Void
   
   @State private var selectedCard: GameMode?
   @State private var isAnimating = false
   
   init(
       selectedMode: Binding<GameMode>,
       startGame: @escaping () -> Void,
       style: GameModeStyle? = nil
   ) {
       self._selectedMode = selectedMode
       self.startGame = startGame
       let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
       _style = StateObject(wrappedValue: initialStyle)
       self.locale = GameModeLocale()
   }
   
   var body: some View {
       BaseScreen(screen: .game) {
           VStack(spacing: style.spacing) {
               Text(locale.selectModeTitle.uppercased())
                   .font(style.titleStyle.font)
                   .foregroundColor(style.titleStyle.color)
                   .padding(.top)
                   .opacity(isAnimating ? 1 : 0)
                   .offset(y: isAnimating ? 0 : 20)
               
               VStack(spacing: style.cardSpacing) {
                   GameModeViewCard(
                       mode: .practice,
                       icon: "graduationcap.fill",
                       title: locale.practiceTitle,
                       description: locale.practiceDescription,
                       style: style,
                       isSelected: selectedCard == .practice,
                       onSelect: { selectMode(.practice) }
                   )
                   //.withAppearanceAnimation(delay: 0.1, isAnimating: isAnimating)
                   
                   GameModeViewCard(
                       mode: .survival,
                       icon: "heart.fill",
                       title: locale.survivalTitle,
                       description: locale.survivalDescription,
                       style: style,
                       isSelected: selectedCard == .survival,
                       onSelect: { selectMode(.survival) }
                   )
                   //.withAppearanceAnimation(delay: 0.2, isAnimating: isAnimating)
                   
                   GameModeViewCard(
                       mode: .timeAttack,
                       icon: "timer",
                       title: locale.timeAttackTitle,
                       description: locale.timeAttackDescription,
                       style: style,
                       isSelected: selectedCard == .timeAttack,
                       onSelect: { selectMode(.timeAttack) }
                   )
                   //.withAppearanceAnimation(delay: 0.3, isAnimating: isAnimating)
               }
               .padding(style.padding)
           }
           .onAppear {
               withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                   isAnimating = true
               }
           }
       }
   }
   
   private func selectMode(_ mode: GameMode) {
       withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
           selectedCard = mode
       }
       selectedMode = mode
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
           startGame()
       }
   }
}
