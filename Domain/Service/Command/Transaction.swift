//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol Transaction {
    func perform(_ block: @escaping () -> Void)
    func perform<T>(_ block: @escaping () throws -> T) async throws -> T
    func begin() throws
    func commit() throws
    func cancel() throws
}
