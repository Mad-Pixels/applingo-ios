protocol DictionaryRepositoryProtocol {
    func fetch(
            searchText: String?,
            offset: Int,
            limit: Int
        ) throws -> [DictionaryItemModel]
    func save(_ dictionary: DictionaryItemModel) throws
    func update(_ dictionary: DictionaryItemModel) throws
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws
    func delete(_ dictionary: DictionaryItemModel) throws
}

protocol WordRepositoryProtocol {
    func fetch(
            searchText: String?,
            offset: Int,
            limit: Int
        ) throws -> [WordItemModel]
    func save(_ word: WordItemModel) throws
    func update(_ word: WordItemModel) throws
    func delete(_ word: WordItemModel) throws
}

protocol APIRepositoryProtocol {
    func getDictionaries() async throws -> [DictionaryItemModel]
    func getCategories() async throws -> CategoryItemModel
}
