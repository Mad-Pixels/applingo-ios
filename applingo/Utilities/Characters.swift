enum ScriptType {
    case hebrew
    case cyrillic
    case latin
    case devanagari
    case arabic
    case thai
    case japanese
    case korean
    
    var range: ClosedRange<UInt32> {
        switch self {
        case .hebrew:     return 0x05D0...0x05EA
        case .cyrillic:   return 0x0430...0x044F
        case .latin:      return 0x0061...0x007A
        case .devanagari: return 0x0900...0x097F
        case .arabic:     return 0x0600...0x06FF
        case .thai:       return 0x0E00...0x0E7F
        case .japanese:   return 0x3040...0x309F
        case .korean:     return 0xAC00...0xD7AF
        }
    }
    
    var excludedRanges: [ClosedRange<UInt32>] {
        switch self {
        case .hebrew:
            return [0x0591...0x05C7, 0x05EB...0x05EF]
        case .cyrillic:
            return [0x0450...0x045F]
        default:
            return []
        }
    }
    
    static func detect(from text: String) -> ScriptType? {
        guard let firstChar = text.unicodeScalars.first else { return nil }
        let value = firstChar.value
        
        for script in [
            ScriptType.hebrew,
            ScriptType.cyrillic,
            ScriptType.latin,
            ScriptType.devanagari,
            ScriptType.arabic,
            ScriptType.thai,
            ScriptType.japanese,
            ScriptType.korean
        ] {
            if (script.range.lowerBound...script.range.upperBound).contains(value) {
                return script
            }
        }
        
        return nil
    }
    
    func getCharacters() -> [Character] {
        var characters: [Character] = []
        
        for value in range {
            if excludedRanges.contains(where: { $0.contains(value) }) {
                continue
            }
            
            guard let scalar = UnicodeScalar(value),
                  let char = Character(String(scalar)).validForDisplay() else {
                continue
            }
            characters.append(char)
        }
        return characters
    }
}
