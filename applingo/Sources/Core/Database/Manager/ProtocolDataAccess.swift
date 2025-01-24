import Foundation

protocol DictionaryRepositoryProtocol {
    func fetch(
        search: String?,
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
    ) throws -> [DatabaseModelWord]
    func fetchCache(
        count: Int
    ) throws -> [DatabaseModelWord]
    func save(_ word: DatabaseModelWord) throws
    func update(_ word: DatabaseModelWord) throws
    func delete(_ word: DatabaseModelWord) throws
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
