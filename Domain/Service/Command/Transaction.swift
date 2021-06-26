//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol Transaction {
    func perform(_ block: @escaping () -> Void)
    func begin() throws
    func commit() throws
    func cancel() throws
}
