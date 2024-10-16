import Foundation

struct DictionaryQueryRequest: Codable, Equatable {
    var id: String?
    var name: String?
    var categoryMain: String?
    var categorySub: String?
    var author: String?
    var isPublic: Bool?
    var code: String?
    var lastEvaluated: String?

    init(id: String? = nil, name: String? = nil, categoryMain: String? = nil, categorySub: String? = nil, author: String? = nil, isPublic: Bool? = nil, code: String? = nil, lastEvaluated: String? = nil) {
        self.id = id
        self.name = name
        self.categoryMain = categoryMain
        self.categorySub = categorySub
        self.author = author
        self.isPublic = isPublic
        self.code = code
        self.lastEvaluated = lastEvaluated
    }
}
