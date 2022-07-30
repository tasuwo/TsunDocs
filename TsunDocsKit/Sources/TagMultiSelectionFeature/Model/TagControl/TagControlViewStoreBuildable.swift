//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
public protocol TagControlViewStoreBuildable {
    @MainActor
    func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency>
}

#if DEBUG

public class TagControlViewStoreBuilderMock: TagControlViewStoreBuildable {
    private let dependency: TagControlDependency

    public init(dependency: TagControlDependency = TagControlDependencyMock()) {
        self.dependency = dependency
    }

    public func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency> {
        let controlStore = Store(initialState: TagControlState(),
                                 dependency: dependency,
                                 reducer: TagControlReducer())
        return ViewStore(store: controlStore)
    }
}

#endif
