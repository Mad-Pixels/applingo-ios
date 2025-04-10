class GameSettingItemInt: GameSettingItemSelect<Int> {
    override init(
        id: String,
        name: String,
        defaultValue: Int = 0,
        options: [Int],
        onChange: ((Int) -> Void)? = nil
    ) {
        super.init(id: id, name: name, defaultValue: defaultValue, options: options, onChange: onChange)
    }
}
