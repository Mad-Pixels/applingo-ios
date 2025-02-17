import SwiftUI

/// A simple cache for storing computed font sizes for given text strings.
final internal class TextSizeCache {
    private static var cache: [String: CGFloat] = [:]
    private static let maxCacheSize = 100
    
    /// Returns a cached font size for the given text if available.
    static func getCachedSize(for text: String) -> CGFloat? {
        return cache[text]
    }
    
    /// Caches the given font size for the provided text.
    static func cacheSize(_ size: CGFloat, for text: String) {
        if cache.count >= maxCacheSize {
            cache.removeAll()
        }
        cache[text] = size
    }
}
