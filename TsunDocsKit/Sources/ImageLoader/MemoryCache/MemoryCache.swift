//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

public final class MemoryCache<Value> {
    class Entry {
        let value: Value

        init(_ value: Value) {
            self.value = value
        }
    }

    private lazy var cache: NSCache<NSString, Entry> = {
        let cache = NSCache<NSString, Entry>()
        cache.totalCostLimit = config.costLimit
        cache.countLimit = config.countLimit
        cache.evictsObjectsWithDiscardedContent = false
        return cache
    }()

    private let lock = NSLock()
    private let config: MemoryCacheConfiguration

    // MARK: - Lifecycle

    public init(config: MemoryCacheConfiguration = .default) {
        self.config = config
    }
}

extension MemoryCache: MemoryCaching {
    // MARK: - MemoryCaching

    public func value(forKey key: String) -> Value? {
        let entry: Entry? = cache.object(forKey: key as NSString)
        return entry?.value
    }

    public func insert(_ value: Value?, forKey key: String) {
        guard let value = value else { return remove(forKey: key) }
        cache.setObject(Entry(value), forKey: key as NSString)
    }

    public func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }

    public subscript(key: String) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            insert(newValue, forKey: key)
        }
    }
}
