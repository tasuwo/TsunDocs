//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

private struct TsundocEditThumbnailStoreBuilderKey: EnvironmentKey {
    struct Builder: TsundocEditThumbnailStoreBuildable {
        func buildTsundocEditThumbnailStore() -> ViewStore<TsundocEditThumbnailState, TsundocEditThumbnailAction, TsundocEditThumbnailDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TsundocEditThumbnailStoreBuildable = Builder()
}

public extension EnvironmentValues {
    var tsundocEditThumbnailStoreBuilder: TsundocEditThumbnailStoreBuildable {
        get { self[TsundocEditThumbnailStoreBuilderKey.self] }
        set { self[TsundocEditThumbnailStoreBuilderKey.self] = newValue }
    }
}
