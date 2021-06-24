//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol Transaction {
    func begin() throws
    func commit() throws
    func cancel() throws
}
