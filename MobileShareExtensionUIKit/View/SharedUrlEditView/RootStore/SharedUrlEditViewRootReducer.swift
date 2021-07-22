//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

public typealias SharedUrlEditViewRootDependency = SharedUrlEditViewDependency
    & SharedUrlImageDependency
    & TagGridDependency

private typealias RootState = SharedUrlEditViewRootState
private typealias RootAction = SharedUrlEditViewRootAction

public let sharedUrlEditViewRootReducer = combine(
    contramap(RootAction.mappingToEdit, RootState.mappingToEdit, { $0 as SharedUrlEditViewRootDependency })(SharedUrlEditViewReducer()),
    contramap(RootAction.mappingToImage, RootState.mappingToImage, { $0 })(TsundocEditThumbnailReducer()),
    contramap(RootAction.mappingToTagGrid, RootState.mappingToTagGrid, { $0 })(TagGridReducer())
)
