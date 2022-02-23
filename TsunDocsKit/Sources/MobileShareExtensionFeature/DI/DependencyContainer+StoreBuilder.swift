//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TagKit

extension DependencyContainer: TagControlViewStoreBuildable {
    // MARK: - TagControlViewStoreBuildable

    public func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency> {
        let store = Store(initialState: TagControlState(),
                          dependency: self,
                          reducer: TagControlReducer())
        return ViewStore(store: store)
    }
}

extension DependencyContainer: TagMultiSelectionStoreBuildable {
    // MARK: - TagMultiSelectionStoreBuildable

    public func buildTagMultiSelectionStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiSelectionState, TagMultiSelectionAction, TagMultiSelectionDependency> {
        let store = Store(initialState: TagMultiSelectionState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: TagMultiSelectionReducer())
        return ViewStore(store: store)
    }
}
