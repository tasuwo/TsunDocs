//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public struct Ordered<Value: Hashable>: Hashable {
    // MARK: - Properties

    public let index: Int
    public let value: Value

    // MARK: - Initializers

    public init(index: Int, value: Value) {
        self.index = index
        self.value = value
    }
}
