//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import Environment
import Foundation

public class NavigationStackDependencyContainer: ObservableObject {
    @Published var stackRouter: StackRouter
    let container: DependencyContainer
    var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init(router: StackRouter, container: DependencyContainer) {
        self.stackRouter = router
        self.container = container

        router.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}

extension NavigationStackDependencyContainer: HasRouter {
    public var router: Router { stackRouter }
}
