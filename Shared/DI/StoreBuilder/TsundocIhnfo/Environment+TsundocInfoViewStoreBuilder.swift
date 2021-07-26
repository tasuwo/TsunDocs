//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct TsundocInfoViewStoreBuilderKey: EnvironmentKey {
    static let defaultValue: TsundocInfoViewStoreBuildable = SceneDependencyContainer(AppDependencyContainer())
}

extension EnvironmentValues {
    var tsundocInfoViewStoreBuilder: TsundocInfoViewStoreBuildable {
        get { self[TsundocInfoViewStoreBuilderKey.self] }
        set { self[TsundocInfoViewStoreBuilderKey.self] = newValue }
    }
}
