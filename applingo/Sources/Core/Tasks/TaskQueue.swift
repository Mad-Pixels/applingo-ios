import Foundation

@MainActor
final class TaskQueue {
    static let shared = TaskQueue()
    
    private let storage = TaskStorage()
    
    private var tasks: [any AbstractTask] = []
    private var isProcessing = false
    
    private init() {
        tasks = storage.all()
    }
    
    /// Enqueues a new task and attempts execution.
    func enqueue(_ task: any AbstractTask) {
        if tasks.contains(where: { $0.id == task.id }) {
            Logger.debug("[TaskQueue] Task already in queue: \(task.id)")
            return
        }

        tasks.append(task)
        storage.add(task)
        Logger.debug("[TaskQueue] Enqueued task: \(task.id)")
        processNext()
    }
    
    /// Manually restarts processing loop, e.g. after foreground event.
    func resume() {
        Logger.debug("[TaskQueue] Resuming processing")
        processNext()
    }
    
    /// Clears all pending tasks (dangerous).
    func clear() {
        tasks.removeAll()
        storage.clear()
        Logger.debug("[TaskQueue] Cleared all tasks")
    }
    
    private func scheduleResume(after delay: TimeInterval) {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            resume()
        }
    }

    private func backoffDelay(for attempt: Int) -> TimeInterval {
        return min(pow(2.0, Double(attempt)), 300)
    }

    private func processNext() {
        guard !isProcessing else { return }
        guard let task = tasks.first else { return }

        if let next = task.nextAttemptAt, next > Date() {
            scheduleResume(after: next.timeIntervalSinceNow)
            return
        }

        isProcessing = true

        Task {
            let result = await TaskExecutor.run(task)

            switch result {
            case .some(true):
                tasks.removeFirst()
                storage.del(id: task.id)

            case .some(false):
                var newTask = task
                newTask.retryCount += 1

                if newTask.maxRetryCount > 0 && newTask.retryCount >= newTask.maxRetryCount {
                    tasks.removeFirst()
                    storage.del(id: task.id)
                } else {
                    let delay = backoffDelay(for: newTask.retryCount)
                    newTask.nextAttemptAt = Date().addingTimeInterval(delay)
                    tasks[0] = newTask
                    storage.add(newTask)
                }

            case .none:
                tasks.removeFirst()
                storage.del(id: task.id)
            }

            isProcessing = false
            processNext()
        }
    }
}
