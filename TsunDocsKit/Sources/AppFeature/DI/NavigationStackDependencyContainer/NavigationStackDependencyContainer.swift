//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Foundation
import Environment

public class NavigationStackDependencyContainer: ObservableObject {
    @Published var router: StackRouter
    let sceneDependencyContainer: SceneDependencyContainer

    // MARK: - Initializers

    public init(router: StackRouter, container: SceneDependencyContainer) {
        self.router = router
        sceneDependencyContainer = container
    }
}
