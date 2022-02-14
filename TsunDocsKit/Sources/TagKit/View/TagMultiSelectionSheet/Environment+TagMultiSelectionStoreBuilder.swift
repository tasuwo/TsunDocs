//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TagMultiSelectionStoreBuilderKey: EnvironmentKey {
    struct Builder: TagMultiSelectionStoreBuildable {
        func buildTagMultiSelectionStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiSelectionState, TagMultiSelectionAction, TagMultiSelectionDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TagMultiSelectionStoreBuildable = Builder()
}

public extension EnvironmentValues {
    var tagMultiSelectionStoreBuilder: TagMultiSelectionStoreBuildable {
        get { self[TagMultiSelectionStoreBuilderKey.self] }
        set { self[TagMultiSelectionStoreBuilderKey.self] = newValue }
    }
}
