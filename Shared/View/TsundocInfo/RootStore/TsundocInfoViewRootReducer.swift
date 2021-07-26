//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

typealias TsundocInfoViewRootDependency = TsundocInfoViewDependency
    & TagGridDependency

private typealias RootState = TsundocInfoViewRootState
private typealias RootAction = TsundocInfoViewRootAction

let tsundocInfoViewRootReducer = combine(
    contramap(RootAction.mappingToInfo, RootState.mappingToInfo, { $0 as TsundocInfoViewRootDependency })(TsundocInfoViewReducer()),
    contramap(RootAction.mappingToTagGrid, RootState.mappingToTagGrid, { $0 })(TagGridReducer())
)
