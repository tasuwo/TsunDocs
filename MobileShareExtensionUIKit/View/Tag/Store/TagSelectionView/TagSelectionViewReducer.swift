//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

typealias TagSelectionViewDependency = TagControlDependency

private typealias RootState = TagSelectionViewState
private typealias RootAction = TagSelectionViewAction

let tagSelectionViewReducer = combine(
    contramap(RootAction.mappingToMultiSelection,
              RootState.mappingToMultiSelection,
              { $0 as TagSelectionViewDependency })(tagMultiSelectionReducer),
    contramap(RootAction.mappingToControl, RootState.mappingToControl, { $0 })(TagControlReducer())
)
