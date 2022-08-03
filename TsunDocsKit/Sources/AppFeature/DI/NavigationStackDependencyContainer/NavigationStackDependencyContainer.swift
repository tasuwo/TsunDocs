//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Foundation

public class NavigationStackDependencyContainer: ObservableObject {
    let sceneDependencyContainer: SceneDependencyContainer

    // MARK: - Initializers

    public init(_ container: SceneDependencyContainer) {
        sceneDependencyContainer = container
    }
}
