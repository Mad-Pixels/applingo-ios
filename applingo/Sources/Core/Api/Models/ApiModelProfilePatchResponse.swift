import Foundation

/// A model representing the response for patching a profile via the API.
struct ApiModelProfilePatchResponse: Codable {
    /// The data container holding the profile information.
    let data: ProfileData
}

/// A container for profile data returned by the API.
struct ProfileData: Codable {
    /// The user's current level.
    let level: Int64
    
    /// The user's current experience points.
    let xp: Int64
}
