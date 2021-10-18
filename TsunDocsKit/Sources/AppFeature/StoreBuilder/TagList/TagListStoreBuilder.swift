//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

/// @mockable
protocol TagListStoreBuildable {
    @MainActor
    func buildTagListStore() -> ViewStore<TagListControlState, TagListControlAction, TagListControlDependency>
}
