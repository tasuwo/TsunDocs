//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public typealias TagSelectionViewDependency = TagMultiSelectionViewDependency
    & TagControlDependency

private typealias RootState = TagMultiAdditionViewState
private typealias RootAction = TagMultiAdditionViewAction

public let TagMultiAdditionViewReducer = combine(
    contramap(RootAction.mappingToMultiSelection,
              RootState.mappingToMultiSelection,
              { $0 as TagSelectionViewDependency })(tagMultiSelectionReducer),
    contramap(RootAction.mappingToControl, RootState.mappingToControl, { $0 })(TagControlReducer())
)
