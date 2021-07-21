//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct TagListStoreBuilderKey: EnvironmentKey {
    static let defaultValue: TagListStoreBuildable = SceneDependencyContainer(AppDependencyContainer())
}

extension EnvironmentValues {
    var tagListStoreBuilder: TagListStoreBuildable {
        get { self[TagListStoreBuilderKey.self] }
        set { self[TagListStoreBuilderKey.self] = newValue }
    }
}
