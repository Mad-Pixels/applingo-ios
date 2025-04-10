import Foundation

/// The threshold for a quick response in the quiz (as a fraction).
internal let SWIPE_SCORE_THRESHOLD = 1.2

/// The bonus score awarded for using a special card.
internal let SWIPE_SCORE_SPECIAL_BONUS = 15

/// The bonus score awarded for a quick response.
internal let SWIPE_SCORE_QUICK_BONUS = 5

/// The base score for a successful answer.
internal let SWIPE_SCORE_SUCCESS = 5

/// The threshold for the quiz cache; if the cache drops below this number, it will be refilled.
internal let SWIPE_CACHE_THRESHOLD = 4

/// The maximum size of the quiz cache.
internal let SWIPE_CACHE_SIZE = 50

/// The minimum active words for invoke the game.
internal let SWIPE_MIN_WORDS_IN_CACHE = 6

/// The correct feedback duration.
internal let SWIPE_CORRECT_FEEDBACK_DURATION: TimeInterval = 0.4

/// The incorrect feedback duration.
internal let SWIPE_INCORRECT_FEEDBACK_DURATION: TimeInterval = 0.4
