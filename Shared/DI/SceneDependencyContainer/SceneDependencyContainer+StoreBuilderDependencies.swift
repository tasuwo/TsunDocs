//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

extension SceneDependencyContainer: TsundocListStoreBuildable {
    // MARK: - TsundocListStoreBuildable

    func buildTsundocListStore() -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency> {
        let store = Store(initialState: TsundocListState(tsundocs: []),
                          dependency: self,
                          reducer: TsundocListReducer())
        return ViewStore(store: store)
    }
}

extension SceneDependencyContainer: TagListStoreBuildable {
    // MARK: - TagListStoreBuildable

    func buildTagListStore() -> ViewStore<TagListState, TagListAction, TagListDependency> {
        let store = Store(initialState: TagListState(),
                          dependency: self,
                          reducer: tagListReducer)
        return ViewStore(store: store)
    }
}
