//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

/// @mockable
protocol TsundocListStoreBuildable {
    @MainActor
    func buildTsundocListStore() -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>
}

/// @mockable
protocol TagListStoreBuildable {
    @MainActor
    func buildTagListStore() -> ViewStore<TagListState, TagListAction, TagListDependency>
}
