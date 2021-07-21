//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct TsundocListStoreBuilderKey: EnvironmentKey {
    static let defaultValue: TsundocListStoreBuildable = SceneDependencyContainer(AppDependencyContainer())
}

extension EnvironmentValues {
    var tsundocListStoreBuilder: TsundocListStoreBuildable {
        get { self[TsundocListStoreBuilderKey.self] }
        set { self[TsundocListStoreBuilderKey.self] = newValue }
    }
}
