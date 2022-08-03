//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public class StackRouter: ObservableObject {
    @Published public var stack: NavigationPath = .init()

    // MARK: - Initializers

    public init() {}
}

extension StackRouter: Router {
    // MARK: - Router

    public func push(_ route: any Route) {
        stack.append(route)
    }
}
