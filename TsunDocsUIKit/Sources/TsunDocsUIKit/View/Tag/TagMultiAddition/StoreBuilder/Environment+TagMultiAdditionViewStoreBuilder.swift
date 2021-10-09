//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TagMultiAdditionViewStoreBuilderKey: EnvironmentKey {
    struct Builder: TagMultiAdditionViewStoreBuildable {
        func buildTagMultiAdditionViewStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiAdditionViewState, TagMultiAdditionViewAction, TagMultiAdditionViewDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TagMultiAdditionViewStoreBuildable = Builder()
}

public extension EnvironmentValues {
    var tagMultiAdditionViewStoreBuilder: TagMultiAdditionViewStoreBuildable {
        get { self[TagMultiAdditionViewStoreBuilderKey.self] }
        set { self[TagMultiAdditionViewStoreBuilderKey.self] = newValue }
    }
}
