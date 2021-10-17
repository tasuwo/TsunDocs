//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

public protocol MemoryCaching: AnyObject {
    associatedtype Value

    func value(forKey key: String) -> Value?
    func insert(_ value: Value?, forKey key: String)
    func remove(forKey key: String)
    func removeAll()
    subscript(_ key: String) -> Value? { get set }
}
