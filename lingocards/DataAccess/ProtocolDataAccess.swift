protocol DictionaryRepositoryProtocol {
    func fetch() throws -> [DictionaryItem]
    func save(_ dictionary: DictionaryItem) throws
    func update(_ dictionary: DictionaryItem) throws
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws
    func delete(_ dictionary: DictionaryItem) throws
}

protocol WordRepositoryProtocol {
    func fetch(
            searchText: String?,
            offset: Int,
            limit: Int
        ) throws -> [WordItem]
    func save(_ word: WordItem) throws
    func update(_ word: WordItem) throws
    func delete(_ word: WordItem) throws
}
