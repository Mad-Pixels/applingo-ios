import Foundation

final internal class ProfileStorage {
    private var internalJson: String?

    init() {
        loadFromStorage()
    }

    func get() -> ProfileModel {
        guard
            let json = internalJson,
            let data = json.data(using: .utf8),
            let profile = try? JSONDecoder().decode(ProfileModel.self, from: data)
        else {
            return .default
        }
        return profile
    }

    func addXp(_ amount: Int64) {
        var profile = get()
        profile.xp += amount
        profile.recalculateLevel()
        save(profile)
    }

    private func save(_ profile: ProfileModel) {
        if let data = try? JSONEncoder().encode(profile),
           let json = String(data: data, encoding: .utf8) {
            internalJson = json
            persist()
        }
    }

    private func loadFromStorage() {
        internalJson = AppStorage.shared.profile
    }

    private func persist() {
        if let json = internalJson {
            AppStorage.shared.profile = json
        }
    }
}
