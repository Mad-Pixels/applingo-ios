import SwiftUI

struct GameModeModel {
    let type: GameModeType
    
    let icon: String
    let title: String
    let description: String
    
    /// Creates a `GameModeModel` for the practice mode.
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
