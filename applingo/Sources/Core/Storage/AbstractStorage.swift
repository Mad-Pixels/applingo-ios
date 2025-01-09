protocol AbstractStorage {
    func getValue(for key: String) -> String
    func setValue(_ value: String, for key: String)
}
