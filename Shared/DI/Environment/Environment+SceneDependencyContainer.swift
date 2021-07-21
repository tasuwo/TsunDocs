//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct SceneDependencyContainerKey: EnvironmentKey {
    static let defaultValue = SceneDependencyContainer(AppDependencyContainer())
}

extension EnvironmentValues {
    var sceneDependencyContainer: SceneDependencyContainer {
        get { self[SceneDependencyContainerKey.self] }
        set { self[SceneDependencyContainerKey.self] = newValue }
    }
}
