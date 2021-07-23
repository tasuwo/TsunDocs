//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
public protocol TagGridStoreBuildable {
    @MainActor
    func buildTagGridStore() -> ViewStore<TagGridState, TagGridAction, TagGridDependency>
}
