class GameSettingItemInt: GameSettingItemSelect<Int> {
    init(
        id: String,
        name: String,
        defaultValue: Int = 0,
        range: ClosedRange<Int>,
        onChange: ((Int) -> Void)? = nil
    ) {
        let options = Array(range)
        super.init(id: id, name: name, defaultValue: defaultValue, options: options, onChange: onChange)
    }
}
