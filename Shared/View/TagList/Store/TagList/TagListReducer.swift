//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

typealias TagListDependency = TagGridDependency
    & TagListControlDependency

private typealias RootState = TagListState
private typealias RootAction = TagListAction

let tagListReducer = combine(
    contramap(RootAction.mappingToGird, RootState.mappingToGird, { $0 as TagListDependency })(TagGridReducer()),
    contramap(RootAction.mappingToControl, RootState.mappingToControl, { $0 })(TagListControlReducer())
)
