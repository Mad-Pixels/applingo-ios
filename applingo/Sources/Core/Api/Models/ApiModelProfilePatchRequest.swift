import Foundation

struct ApiModelProfilePatchRequest: Codable {
    let id: String
    let level: Int64
    let xp: Int64
}
