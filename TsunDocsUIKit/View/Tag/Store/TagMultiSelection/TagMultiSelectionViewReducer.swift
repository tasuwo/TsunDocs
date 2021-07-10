//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public typealias TagMultiSelectionViewDependency = Void

private typealias RootState = TagMultiSelectionViewState
private typealias RootAction = TagMultiSelectionViewAction

public let tagMultiSelectionReducer = combine(
    contramap(RootAction.mappingToSelection, RootState.mappingToSelection, { $0 as TagMultiSelectionViewDependency })(TagSelectionReducer()),
    contramap(RootAction.mappingToFilter, RootState.mappingToFilter, { $0 })(TagFilterReducer())
)
