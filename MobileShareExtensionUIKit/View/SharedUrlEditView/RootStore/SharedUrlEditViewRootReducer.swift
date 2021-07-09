//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public typealias SharedUrlEditViewRootDependency = SharedUrlEditViewDependency
    & SharedUrlImageDependency

private typealias RootState = SharedUrlEditViewRootState
private typealias RootAction = SharedUrlEditViewRootAction

public let sharedUrlEditViewRootReducer = combine(
    contramap(RootAction.mappingToEdit, RootState.mappingToEdit, { $0 as SharedUrlEditViewRootDependency })(SharedUrlEditViewReducer()),
    contramap(RootAction.mappingToImage, RootState.mappingToImage, { $0 })(SharedUrlImageReducer())
)
