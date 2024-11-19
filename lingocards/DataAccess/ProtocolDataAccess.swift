import Foundation

protocol DictionaryRepositoryProtocol {
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [DictionaryItemModel]
    func save(_ dictionary: DictionaryItemModel) throws
    func update(_ dictionary: DictionaryItemModel) throws
    func delete(_ dictionary: DictionaryItemModel) throws
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws
    func fetchDisplayName(byTableName tableName: String) throws -> String
}

protocol WordRepositoryProtocol {
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [WordItemModel]
    func fetchCache(
        count: Int
    ) throws -> [WordItemModel]
    func save(_ word: WordItemModel) throws
    func update(_ word: WordItemModel) throws
    func delete(_ word: WordItemModel) throws
}

protocol ApiRepositoryProtocol {
    func getDictionaries(
        request: ApiDictionaryQueryRequestModel?
    ) async throws -> (
        dictionaries: [DictionaryItemModel], lastEvaluated: String?
    )
    func downloadDictionary(_ dictionary: DictionaryItemModel) async throws -> URL
    func getCategories() async throws -> CategoryItemModel
}
