//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

struct Factory<T> {
    // MARK: - Properties

    private let block: () -> T

    // MARK: - Initializers

    init(_ block: @escaping () -> T) {
        self.block = block
    }

    // MARK: - Methods

    func make() -> T {
        block()
    }
}
