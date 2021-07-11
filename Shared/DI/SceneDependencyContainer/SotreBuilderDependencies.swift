//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

/// @mockable
protocol TsundocListStoreBuildable {
    func buildTsundocListStore() -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>
}

/// @mockable
protocol TagListStoreBuildable {
    func buildTagListStore() -> ViewStore<TagListState, TagListAction, TagListDependency>
}
