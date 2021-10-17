//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

public struct Factory<T> {
    // MARK: - Properties

    private let block: () -> T

    // MARK: - Initializers

    public init(_ block: @escaping () -> T) {
        self.block = block
    }

    // MARK: - Methods

    public func make() -> T {
        block()
    }
}
