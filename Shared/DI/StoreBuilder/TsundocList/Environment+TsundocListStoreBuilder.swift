//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

private struct TsundocListStoreBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TsundocListStoreBuildable {
        func buildTsundocListStore(query: TsundocListState.Query) -> ViewStore<TsundocListState, TsundocListAction, TsundocListDependency> {
            fatalError("Not Implemented")
        }
    }

    static let defaultValue: TsundocListStoreBuildable = DefaultBuilder()
}

extension EnvironmentValues {
    var tsundocListStoreBuilder: TsundocListStoreBuildable {
        get { self[TsundocListStoreBuilderKey.self] }
        set { self[TsundocListStoreBuilderKey.self] = newValue }
    }
}
