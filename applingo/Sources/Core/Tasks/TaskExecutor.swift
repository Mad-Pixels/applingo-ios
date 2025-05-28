import Foundation

@MainActor
enum TaskExecutor {
    private static var runtimeFlags: [String: Bool] = [:]

    static func setFlag(_ key: String, value: Bool) {
        runtimeFlags[key] = value
    }

    static func flag(_ key: String) -> Bool {
        runtimeFlags[key] ?? false
    }

    /// Executes the task. Returns:
    /// - `true`: success
    /// - `false`: failed, should retry
    /// - `nil`: unrecoverable, should delete immediately
    static func run(_ task: any AbstractTask) async -> Bool? {
        if let required = (task as? AbstractConditional)?.requiredFlags {
            let unmet = required.first(where: { flag($0) == false })
            if let unmet = unmet {
                Logger.debug("[TaskExecutor] Skipping & dropping task \(task.id) — missing flag: \(unmet)")
                return nil
            }
        }

        do {
            try await task.execute()
            Logger.debug("[TaskExecutor] Executed task: \(task.id)")
            return true
        } catch {
            Logger.debug("[TaskExecutor] Failed task: \(task.id)", metadata: ["error": error.localizedDescription])
            return false
        }
    }
}
