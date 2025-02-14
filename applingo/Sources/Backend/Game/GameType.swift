/// An enumeration representing the various types of games available in the application.
///
/// Each case corresponds to a distinct game experience:
/// - `quiz`: A game where players answer questions and are scored based on accuracy and speed.
/// - `match`: A game where players match items or pairs, testing memory and recognition skills.
/// - `swipe`: A game that involves quick swipe gestures to interact with elements, emphasizing speed.
enum GameType: Hashable {
    case quiz
    case match
    case swipe
}
