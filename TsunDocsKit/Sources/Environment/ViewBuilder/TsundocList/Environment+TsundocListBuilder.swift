//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TsundocListBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TsundocListBuildable {
        func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, query: TsundocListQuery) -> AnyView {
            assertionFailure("Not Implemented")
            return AnyView(EmptyView())
        }
    }

    static let defaultValue: TsundocListBuildable = DefaultBuilder()
}

public extension EnvironmentValues {
    var tsundocListBuilder: TsundocListBuildable {
        get { self[TsundocListBuilderKey.self] }
        set { self[TsundocListBuilderKey.self] = newValue }
    }
}
