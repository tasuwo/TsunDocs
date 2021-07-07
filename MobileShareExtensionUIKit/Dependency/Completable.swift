//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol Completable {
    func complete()
    func cancel(with: Error)
}
