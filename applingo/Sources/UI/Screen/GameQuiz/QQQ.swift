import SwiftUI
import Combine
import Foundation

struct ScoreChange: Identifiable {
    let id = UUID()
    let totalValue: Int
    let bonusTypes: [BonusType]
    var timestamp = Date()
    
    enum BonusType {
        case quickResponse
        case specialCard
        case streak
        
        var icon: String {
            switch self {
            case .quickResponse: return "bolt.circle.fill"
            case .specialCard: return "star.circle.fill"
            case .streak: return "flame.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .quickResponse: return .blue
            case .specialCard: return .yellow
            case .streak: return .orange
            }
        }
    }
}

struct ScoreChangeView: View {
    let change: ScoreChange
    let style: GameTabStyle
    
    var body: some View {
        HStack(spacing: 8) {
            // Значение очков
            Text(change.totalValue >= 0 ? "+\(change.totalValue)" : "\(change.totalValue)")
                .foregroundColor(change.totalValue >= 0 ? .green : .red)
                .font(style.valueFont)
            
            // Иконки бонусов
            if !change.bonusTypes.isEmpty {
                HStack(spacing: 4) {
                    ForEach(change.bonusTypes, id: \.icon) { bonus in
                        Image(systemName: bonus.icon)
                            .foregroundColor(bonus.color)
                    }
                }
            }
        }
        .transition(.scale.combined(with: .opacity))
        .animation(.easeInOut, value: change.id)
    }
}

final class ScoreChangeManager: ObservableObject {
    @Published private(set) var changes: [ScoreChange] = []
    private let displayDuration: TimeInterval = 1.5
    
    func addChange(_ change: ScoreChange) {
        changes.append(change)
        
        // Удаляем изменение после заданного времени
        DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) { [weak self] in
            self?.changes.removeAll { $0.id == change.id }
        }
    }
}


struct ScoreChangesContainer: View {
    @ObservedObject var manager: ScoreChangeManager
    let style: GameTabStyle
    
    var body: some View {
        VStack {
            ForEach(manager.changes) { change in
                ScoreChangeView(change: change, style: style)
            }
        }
    }
}
