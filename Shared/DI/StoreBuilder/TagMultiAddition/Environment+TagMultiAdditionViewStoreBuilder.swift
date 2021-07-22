//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct TagMultiAdditionViewStoreBuilderKey: EnvironmentKey {
    static let defaultValue: TagMultiAdditionViewStoreBuildable = SceneDependencyContainer(AppDependencyContainer())
}

extension EnvironmentValues {
    var tagMultiAdditionViewStoreBuilder: TagMultiAdditionViewStoreBuildable {
        get { self[TagMultiAdditionViewStoreBuilderKey.self] }
        set { self[TagMultiAdditionViewStoreBuilderKey.self] = newValue }
    }
}
