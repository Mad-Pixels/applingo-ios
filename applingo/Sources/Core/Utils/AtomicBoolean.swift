import Foundation

/// A thread-safe atomic boolean implementation.
final class AtomicBoolean {
    private let lock = NSLock()
    private var _value: Bool

    init(_ initialValue: Bool) {
        self._value = initialValue
    }

    /// The current value of the atomic boolean.
    var value: Bool {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _value
        }
        set {
            lock.lock()
            _value = newValue
            lock.unlock()
        }
    }

    /// Atomically sets the value to `true`.
    func setTrue() {
        value = true
    }

    /// Atomically sets the value to `false`.
    func setFalse() {
        value = false
    }

    /// Atomically toggles the value and returns the new value.
    func toggle() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        _value.toggle()
        return _value
    }
}
