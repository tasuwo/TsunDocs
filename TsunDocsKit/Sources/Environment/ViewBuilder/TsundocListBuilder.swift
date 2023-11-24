//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable(typealias: TsundocList = SampleView)
public protocol TsundocListBuildable {
    associatedtype TsundocList: View

    @MainActor
    func buildTsundocList(title: String,
                          emptyTile: String,
                          emptyMessage: String?,
                          isTsundocCreationEnabled: Bool,
                          query: TsundocListQuery) -> TsundocList
}
