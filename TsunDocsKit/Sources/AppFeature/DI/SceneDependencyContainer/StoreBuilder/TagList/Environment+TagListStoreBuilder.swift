//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

private struct TagListStoreBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TagListStoreBuildable {
        func buildTagListStore() -> ViewStore<TagListControlState, TagListControlAction, TagListControlDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TagListStoreBuildable = DefaultBuilder()
}

extension EnvironmentValues {
    var tagListStoreBuilder: TagListStoreBuildable {
        get { self[TagListStoreBuilderKey.self] }
        set { self[TagListStoreBuilderKey.self] = newValue }
    }
}
