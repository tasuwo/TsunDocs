//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public class SceneDependencyContainer {
    let appDependencyContainer: AppDependencyContainer

    // MARK: - Initializers

    public init(_ container: AppDependencyContainer) {
        appDependencyContainer = container
    }
}
