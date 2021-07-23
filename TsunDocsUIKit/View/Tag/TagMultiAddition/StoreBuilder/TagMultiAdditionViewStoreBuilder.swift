//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
public protocol TagMultiAdditionViewStoreBuildable {
    @MainActor
    func buildTagMultiAdditionViewStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiAdditionViewState, TagMultiAdditionViewAction, TagMultiAdditionViewDependency>
}
