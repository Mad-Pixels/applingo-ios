import SwiftUI

struct GameModeModel {
    let type: GameModeType
    let icon: String
    let title: String
    let description: String
    
    static func practice(locale: GameModeLocale) -> GameModeModel {
        GameModeModel(
            type: .practice,
            icon: "graduationcap.fill",
            title: locale.screenSubtitlePractice,
            description: locale.screenDescriptionPractice
        )
    }
    
    static func survival(locale: GameModeLocale) -> GameModeModel {
        GameModeModel(
            type: .survival,
            icon: "heart.fill",
            title: locale.screenSubtitleSurvival,
            description: locale.screenDescriptionSurvival
        )
    }
    
    static func time(locale: GameModeLocale) -> GameModeModel {
        GameModeModel(
            type: .time,
            icon: "timer",
            title: locale.screenSubtitleTime,
            description: locale.screenDescriptionTime
        )
    }
}
