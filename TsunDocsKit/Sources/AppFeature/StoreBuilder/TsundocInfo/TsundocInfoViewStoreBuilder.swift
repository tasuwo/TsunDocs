//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
protocol TsundocInfoViewStoreBuildable {
    @MainActor
    func buildTsundocInfoViewStore(tsundoc: Tsundoc) -> ViewStore<TsundocInfoViewState, TsundocInfoViewAction, TsundocInfoViewDependency>
}
