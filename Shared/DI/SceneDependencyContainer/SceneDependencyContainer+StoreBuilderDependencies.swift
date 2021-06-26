//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

extension SceneDependencyContainer: TsundocListStoreBuildable {
    // MARK: - TsundocListStoreBuildable

    func buildTsundocListStore() -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency> {
        let store = Store(initialState: TsundocListState(tsundocs: []),
                          dependency: (),
                          reducer: TsundocListReducer())
        return ViewStore(store: store)
    }
}
