//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TagControlViewStoreBuilderKey: EnvironmentKey {
    struct Builder: TagControlViewStoreBuildable {
        func buildTagControlViewStore() -> ViewStore<TagControlState, TagControlAction, TagControlDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TagControlViewStoreBuildable = Builder()
}

public extension EnvironmentValues {
    var tagControlViewStoreBuilder: TagControlViewStoreBuildable {
        get { self[TagControlViewStoreBuilderKey.self] }
        set { self[TagControlViewStoreBuilderKey.self] = newValue }
    }
}
