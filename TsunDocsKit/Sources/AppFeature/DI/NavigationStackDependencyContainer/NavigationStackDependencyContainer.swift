//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import Environment
import Foundation
import SwiftUI

public class NavigationStackDependencyContainer: ObservableObject {
    @Published public var stack: NavigationPath = .init()
    let container: DependencyContainer
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init(container: DependencyContainer) {
        self.container = container
    }
}

extension NavigationStackDependencyContainer: HasRouter {
    public var router: Router { self }
}

extension NavigationStackDependencyContainer: Router {
    // MARK: - Router

    public func push(_ route: any Route) {
        stack.append(route)
    }

    public func pop() {
        stack.removeLast()
    }
}
