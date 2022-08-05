//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Environment
import Foundation

public class NavigationStackDependencyContainer: ObservableObject {
    let stackRouter: StackRouter
    let container: DependencyContainer

    // MARK: - Initializers

    public init(router: StackRouter, container: DependencyContainer) {
        self.stackRouter = router
        self.container = container
    }
}

extension NavigationStackDependencyContainer: HasRouter {
    public var router: Router { stackRouter }
}
