//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
public protocol TagMultiSelectionStoreBuildable {
    @MainActor
    func buildTagMultiSelectionStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiSelectionState, TagMultiSelectionAction, TagMultiSelectionDependency>
}

#if DEBUG

import PreviewContent

public class TagMultiSelectionStoreBuilderMock: TagMultiSelectionStoreBuildable {
    private let dependency: TagMultiSelectionDependency

    public init(dependency: TagMultiSelectionDependency = TagMultiSelectionDependencyMock()) {
        self.dependency = dependency
    }

    public func buildTagMultiSelectionStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiSelectionState, TagMultiSelectionAction, TagMultiSelectionDependency> {
        let store = Store(initialState: TagMultiSelectionState(selectedIds: selectedIds),
                          dependency: dependency,
                          reducer: TagMultiSelectionReducer())
        return ViewStore(store: store)
    }
}

#endif
