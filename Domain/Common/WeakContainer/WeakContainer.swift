//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

class WeakContainer<T> {
    // MARK: - Properties

    var value: T? {
        return self.internalValue as? T
    }

    private weak var internalValue: AnyObject?

    // MARK: - Initializers

    init(_ value: T) {
        self.internalValue = value as AnyObject
    }
}
