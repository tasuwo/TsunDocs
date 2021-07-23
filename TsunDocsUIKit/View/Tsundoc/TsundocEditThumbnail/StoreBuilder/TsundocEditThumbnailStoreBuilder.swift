//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

/// @mockable
public protocol TsundocEditThumbnailStoreBuildable {
    @MainActor
    func buildTsundocEditThumbnailStore() -> ViewStore<TsundocEditThumbnailState, TsundocEditThumbnailAction, TsundocEditThumbnailDependency>
}
