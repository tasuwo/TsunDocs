//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

public class SceneDependencyContainer: ObservableObject {
    let appDependencyContainer: AppDependencyContainer

    // MARK: - Initializers

    public init(_ container: AppDependencyContainer) {
        appDependencyContainer = container
    }
}
