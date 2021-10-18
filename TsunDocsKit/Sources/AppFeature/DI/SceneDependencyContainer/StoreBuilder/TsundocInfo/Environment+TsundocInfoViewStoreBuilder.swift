//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TsundocInfoViewStoreBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TsundocInfoViewStoreBuildable {
        func buildTsundocInfoViewStore(tsundoc: Tsundoc) -> ViewStore<TsundocInfoViewState, TsundocInfoViewAction, TsundocInfoViewDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TsundocInfoViewStoreBuildable = DefaultBuilder()
}

extension EnvironmentValues {
    var tsundocInfoViewStoreBuilder: TsundocInfoViewStoreBuildable {
        get { self[TsundocInfoViewStoreBuilderKey.self] }
        set { self[TsundocInfoViewStoreBuilderKey.self] = newValue }
    }
}
