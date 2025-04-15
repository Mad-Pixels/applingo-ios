internal struct CloudPendingOperation: Codable {
    let id: String
    let type: CloudPendingOperationType
    let key: String
    let value: String
    let timestamp: Int
}
