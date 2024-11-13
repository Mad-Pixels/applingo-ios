import Foundation

final class SpecialServiceViewModel: ObservableObject {
    private var service = GameSpecialService()
    
    func registerSpecial(_ special: GameSpecialProtocol) {
        service = service.withSpecial(special)
    }
    
    func clear() {
        service = GameSpecialService()
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        service.isSpecial(item)
    }
    
    func getActiveSpecial() -> (any GameSpecialScoringProtocol)? {
        service.getActiveSpecial()
    }
    
    func getModifiers() -> [AnyViewModifier] {
        service.getModifiers()
    }
}
