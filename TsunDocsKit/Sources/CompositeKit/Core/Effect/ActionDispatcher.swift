//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

struct ActionDispatcher<Action: CompositeKit.Action> {
    // MARK: - Properties

    private let action: Action
    private let withContext: (() -> Void) -> Void

    // MARK: - Initializers

    init?(action: Action?, with withContext: ((() -> Void) -> Void)? = nil) {
        guard let action = action else { return nil }
        self.action = action
        self.withContext = withContext ?? { $0() }
    }

    // MARK: - Methods

    func dispatch(_ block: @escaping (Action) -> Void) {
        Task { @MainActor in
            withContext {
                block(action)
            }
        }
    }

    func map<T: CompositeKit.Action>(_ transform: @escaping (Action?) -> T?) -> ActionDispatcher<T>? {
        return ActionDispatcher<T>(action: transform(action), with: withContext)
    }
}
