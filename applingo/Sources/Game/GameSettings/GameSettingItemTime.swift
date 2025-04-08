import SwiftUI

class GameSettingItemTime: GameSettingItemSelect<TimeInterval> {
    init(
        id: String,
        name: String,
        defaultValue: TimeInterval = 90,
        range: ClosedRange<TimeInterval>,
        step: TimeInterval = 30,
        onChange: ((TimeInterval) -> Void)? = nil
    ) {
        let options = stride(from: range.lowerBound, through: range.upperBound, by: step).map { $0 }
        super.init(id: id, name: name, defaultValue: defaultValue, options: options, onChange: onChange)
    }
}
