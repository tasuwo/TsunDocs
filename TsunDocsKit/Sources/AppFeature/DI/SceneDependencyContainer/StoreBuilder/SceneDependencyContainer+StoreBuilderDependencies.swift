//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TagKit

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

extension SceneDependencyContainer: TagControlViewStoreBuildable {
    // MARK: - TagControlViewStoreBuildable

    @MainActor
    func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency> {
        let store = Store(initialState: TagControlState(),
                          dependency: self,
                          reducer: TagControlReducer())
        return ViewStore(store: store)
    }
}

extension SceneDependencyContainer: TagMultiSelectionStoreBuildable {
    // MARK: - TagMultiSelectionStoreBuildable

    @MainActor
    func buildTagMultiSelectionStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiSelectionState, TagMultiSelectionAction, TagMultiSelectionDependency> {
        let store = Store(initialState: TagMultiSelectionState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: TagMultiSelectionReducer())
        return ViewStore(store: store)
    }
}

extension SceneDependencyContainer: TsundocInfoViewStoreBuildable {
    // MARK: - TsundocInfoViewStoreBuildable

    @MainActor
    func buildTsundocInfoViewStore(tsundoc: Tsundoc) -> ViewStore<TsundocInfoViewState, TsundocInfoViewAction, TsundocInfoViewDependency> {
        let store = Store(initialState: TsundocInfoViewState(tsundoc: tsundoc, tags: []),
                          dependency: self,
                          reducer: TsundocInfoViewReducer())
        return ViewStore(store: store)
    }
}
