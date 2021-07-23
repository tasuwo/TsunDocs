//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TagGridStoreBuilderKey: EnvironmentKey {
    struct Builder: TagGridStoreBuildable {
        func buildTagGridStore() -> ViewStore<TagGridState, TagGridAction, TagGridDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TagGridStoreBuildable = Builder()
}

public extension EnvironmentValues {
    var tagGridStoreBuilder: TagGridStoreBuildable {
        get { self[TagGridStoreBuilderKey.self] }
        set { self[TagGridStoreBuilderKey.self] = newValue }
    }
}
