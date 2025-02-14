import SwiftUI

/// A model representing the information needed to display a game mode card in the UI.
///
/// This structure encapsulates the game mode type, an icon, a title, and a description,
/// which are used to inform the user about the available game modes.
///
/// The model also provides static helper methods to conveniently create instances
/// for the practice, survival, and time modes using localized strings from a `GameModeLocale` instance.
struct GameModeModel {
    /// The type of the game mode (practice, survival, or time).
    let type: GameModeType
    /// The name of the icon representing the game mode.
    let icon: String
    /// The title for the game mode.
    let title: String
    /// A description for the game mode.
    let description: String
    
    /// Creates a `GameModeModel` for the practice mode.
    ///
    /// - Parameter locale: A `GameModeLocale` instance providing localized strings.
    /// - Returns: A `GameModeModel` configured for practice mode.
    static func practice(locale: GameModeLocale) -> GameModeModel {
        GameModeModel(
            type: .practice,
            icon: "graduationcap.fill",
            title: locale.screenSubtitlePractice,
            description: locale.screenDescriptionPractice
        )
    }
    
    /// Creates a `GameModeModel` for the survival mode.
    ///
    /// - Parameter locale: A `GameModeLocale` instance providing localized strings.
    /// - Returns: A `GameModeModel` configured for survival mode.
    static func survival(locale: GameModeLocale) -> GameModeModel {
        GameModeModel(
            type: .survival,
            icon: "heart.fill",
            title: locale.screenSubtitleSurvival,
            description: locale.screenDescriptionSurvival
        )
    }
    
    /// Creates a `GameModeModel` for the time mode.
    ///
    /// - Parameter locale: A `GameModeLocale` instance providing localized strings.
    /// - Returns: A `GameModeModel` configured for time mode.
    static func time(locale: GameModeLocale) -> GameModeModel {
        GameModeModel(
            type: .time,
            icon: "timer",
            title: locale.screenSubtitleTime,
            description: locale.screenDescriptionTime
        )
    }
}
