//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

extension ViewStore where State == SharedUrlEditViewRootState, Action == SharedUrlEditViewRootAction, Dependency == SharedUrlEditViewRootDependency {
    var tagGridStore: ViewStore<TagGridState, TagGridAction, TagGridDependency> {
        return self
            .proxy(SharedUrlEditViewRootState.mappingToTagGrid,
                   SharedUrlEditViewRootAction.mappingToTagGrid)
            .viewStore()
    }
}
