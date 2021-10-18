//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct TsunDocsApp: App {
    @Environment(\.appDependencyContainer) var container

    // MARK: - Initializers

    public init() {}

    // MARK: - View

    public var body: some Scene {
        WindowGroup {
            ContentView(container: SceneDependencyContainer(container))
        }
    }
}
