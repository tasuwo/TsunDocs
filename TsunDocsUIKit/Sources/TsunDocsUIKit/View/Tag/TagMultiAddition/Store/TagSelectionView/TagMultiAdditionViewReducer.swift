//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public typealias TagMultiAdditionViewDependency = TagMultiSelectionViewDependency
    & TagControlDependency

private typealias RootState = TagMultiAdditionViewState
private typealias RootAction = TagMultiAdditionViewAction

public let tagMultiAdditionViewReducer = combine(
    contramap(RootAction.mappingToMultiSelection,
              RootState.mappingToMultiSelection,
              { $0 as TagMultiAdditionViewDependency })(tagMultiSelectionReducer),
    contramap(RootAction.mappingToControl, RootState.mappingToControl, { $0 })(TagControlReducer())
)
