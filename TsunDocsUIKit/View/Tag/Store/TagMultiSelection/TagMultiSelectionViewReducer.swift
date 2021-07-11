//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public typealias TagMultiSelectionViewDependency = Void

private typealias RootState = TagMultiSelectionViewState
private typealias RootAction = TagMultiSelectionViewAction

public let tagMultiSelectionReducer = combine(
    contramap(RootAction.mappingToGrid, RootState.mappingToGrid, { $0 as TagMultiSelectionViewDependency })(TagGridReducer()),
    contramap(RootAction.mappingToFilter, RootState.mappingToFilter, { $0 })(TagFilterReducer())
)
