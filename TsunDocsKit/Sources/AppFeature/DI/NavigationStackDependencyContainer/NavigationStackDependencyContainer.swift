//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Environment
import Foundation

public class NavigationStackDependencyContainer: ObservableObject {
    @Published var router: StackRouter
    let container: DependencyContainer

    // MARK: - Initializers

    public init(router: StackRouter, container: DependencyContainer) {
        self.router = router
        self.container = container
    }
}
