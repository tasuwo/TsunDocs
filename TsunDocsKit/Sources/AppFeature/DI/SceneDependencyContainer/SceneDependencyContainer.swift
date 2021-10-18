//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

class SceneDependencyContainer: ObservableObject {
    let appDependencyContainer: AppDependencyContainer

    // MARK: - Initializers

    init(_ container: AppDependencyContainer) {
        appDependencyContainer = container
    }
}
