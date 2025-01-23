import Foundation

protocol DictionaryRepositoryProtocol {
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseModelDictionary]
    func save(_ dictionary: DatabaseModelDictionary) throws
    func update(_ dictionary: DatabaseModelDictionary) throws
    func delete(_ dictionary: DatabaseModelDictionary) throws
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
        dictionaries: [DatabaseModelDictionary], lastEvaluated: String?
    )
    func downloadDictionary(_ dictionary: DatabaseModelDictionary) async throws -> URL
    func getCategories() async throws -> CategoryItemModel
}
