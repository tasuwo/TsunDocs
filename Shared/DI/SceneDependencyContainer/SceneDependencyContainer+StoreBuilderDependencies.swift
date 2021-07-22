//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

extension SceneDependencyContainer: TsundocListStoreBuildable {
    // MARK: - TsundocListStoreBuildable

    @MainActor
    func buildTsundocListStore(query: TsundocListState.Query) -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency> {
        let store = Store(initialState: TsundocListState(query: query),
                          dependency: self,
                          reducer: TsundocListReducer())
        return ViewStore(store: store)
    }
}

extension SceneDependencyContainer: TagListStoreBuildable {
    // MARK: - TagListStoreBuildable

    @MainActor
    func buildTagListStore() -> ViewStore<TagListState, TagListAction, TagListDependency> {
        let store = Store(initialState: TagListState(),
                          dependency: self,
                          reducer: tagListReducer)
        return ViewStore(store: store)
    }
}

extension SceneDependencyContainer: TagMultiAdditionViewStoreBuildable {
    // MARK: - TagListStoreBuildable

    @MainActor
    func buildTagMultiAdditionViewStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiAdditionViewState, TagMultiAdditionViewAction, TagMultiAdditionViewDependency> {
        let store = Store(initialState: TagMultiAdditionViewState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: tagMultiAdditionViewReducer)
        return ViewStore(store: store)
    }
}
