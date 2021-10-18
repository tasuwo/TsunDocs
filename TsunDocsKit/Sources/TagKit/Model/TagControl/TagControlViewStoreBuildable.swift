//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
public protocol TagControlViewStoreBuildable {
    @MainActor
    func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency>
}
