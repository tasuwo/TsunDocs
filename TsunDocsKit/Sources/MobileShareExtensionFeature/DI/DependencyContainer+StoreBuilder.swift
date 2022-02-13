//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TagKit

extension DependencyContainer: TagControlViewStoreBuildable {
    // MARK: - TagControlViewStoreBuildable

    func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency> {
        let store = Store(initialState: TagControlState(),
                          dependency: self,
                          reducer: TagControlReducer())
        return ViewStore(store: store)
    }
}
