//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

extension ViewStore where State == SharedUrlEditViewRootState, Action == SharedUrlEditViewRootAction, Dependency == SharedUrlEditViewRootDependency {
    var tsundocEditThumbnailStore: ViewStore<TsundocEditThumbnailState, TsundocEditThumbnailAction, TsundocEditThumbnailDependency> {
        return self
            .proxy(SharedUrlEditViewRootState.mappingToImage,
                   SharedUrlEditViewRootAction.mappingToImage)
            .viewStore()
    }

    var tagGridStore: ViewStore<TagGridState, TagGridAction, TagGridDependency> {
        return self
            .proxy(SharedUrlEditViewRootState.mappingToTagGrid,
                   SharedUrlEditViewRootAction.mappingToTagGrid)
            .viewStore()
    }
}
