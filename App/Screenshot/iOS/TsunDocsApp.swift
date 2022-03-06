//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import AppFeature
import SwiftUI

@main
struct TsunDocsApp: App {
    // MARK: - View

    var body: some Scene {
        WindowGroup {
            RootView(container: DummyContainer())
        }
    }
}
