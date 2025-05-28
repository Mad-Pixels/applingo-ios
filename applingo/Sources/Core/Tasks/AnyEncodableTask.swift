import Foundation

struct AnyEncodableTask: Codable {
    private enum CodingKeys: String, CodingKey {
        case taskType
        case payload
    }

    private static var registry: [String: Factory] = [:]

    let taskType: String
    let payload: Data

    var task: any AbstractTask {
        guard let factory = Self.registry[taskType] else {
            fatalError("[Task] No factory registered for type: \(taskType)")
        }
        return factory(payload)
    }

    init(_ task: any AbstractTask) {
        self.taskType = (type(of: task) as any AbstractTask.Type).type
        self.payload = try! JSONEncoder().encode(task)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.taskType = try container.decode(String.self, forKey: .taskType)
        self.payload = try container.decode(Data.self, forKey: .payload)
    }

    typealias Factory = (Data) -> any AbstractTask

    static func register<T: AbstractTask>(_ type: T.Type) {
        registry[T.type] = { data in
            try! JSONDecoder().decode(T.self, from: data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(taskType, forKey: .taskType)
        try container.encode(payload, forKey: .payload)
    }
}
