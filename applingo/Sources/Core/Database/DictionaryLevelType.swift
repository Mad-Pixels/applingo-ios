/// An enumeration representing the different levels of a dictionary.
/// Levels are based on common language proficiency frameworks.
enum DictionaryLevelType: String, CaseIterable, Codable {
    /// Internal or undefined level, used for system-level dictionaries.
    case undefined = "internal"
    
    /// Beginner level, equivalent to A1 in the CEFR framework.
    case beginner = "A1"
    
    /// Elementary level, equivalent to A2 in the CEFR framework.
    case elementary = "A2"
    
    /// Intermediate level, equivalent to B1 in the CEFR framework.
    case intermediate = "B1"
    
    /// Upper-intermediate level, equivalent to B2 in the CEFR framework.
    case upperIntermediate = "B2"
    
    /// Advanced level, equivalent to C1 in the CEFR framework.
    case advanced = "C1"
    
    /// Proficient level, equivalent to C2 in the CEFR framework.
    case proficient = "C2"
}
