//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

@main
struct TsunDocsApp: App {
    @Environment(\.appDependencyContainer) var container

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.sceneDependencyContainer, SceneDependencyContainer(container))
        }
    }
}
