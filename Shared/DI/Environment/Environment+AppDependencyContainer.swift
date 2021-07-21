//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct AppDependencyContainerKey: EnvironmentKey {
    static let defaultValue = AppDependencyContainer()
}

extension EnvironmentValues {
    var appDependencyContainer: AppDependencyContainer {
        get { self[AppDependencyContainerKey.self] }
        set { self[AppDependencyContainerKey.self] = newValue }
    }
}
