//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

/// @mockable
protocol TsundocListStoreBuildable {
    @MainActor
    func buildTsundocListStore(query: TsundocListState.Query) -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>
}
