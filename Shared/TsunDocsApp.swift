//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

@main
struct TsunDocsApp: App {
    @StateObject var container = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(container: SceneDependencyContainer(container))
        }
    }
}
