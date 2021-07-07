//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

typealias SharedUrlEditViewRootDependency = SharedUrlEditViewDependency
    & SharedUrlImageDependency

private typealias RootState = SharedUrlEditViewRootState
private typealias RootAction = SharedUrlEditViewRootAction

let sharedUrlEditViewRootReducer = combine(
    contramap(RootAction.mappingToEdit, RootState.mappingToEdit, { $0 as SharedUrlEditViewRootDependency })(SharedUrlEditViewReducer()),
    contramap(RootAction.mappingToImage, RootState.mappingToImage, { $0 })(SharedUrlImageReducer())
)
