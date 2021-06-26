//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

protocol TsundocListStoreBuildable {
    func buildTsundocListStore() -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>
}
