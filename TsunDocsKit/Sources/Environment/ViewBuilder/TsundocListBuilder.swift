//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable
public protocol TsundocListBuildable {
    @MainActor
    func buildTsundocList(title: String,
                          emptyTile: String,
                          emptyMessage: String?,
                          isTsundocCreationEnabled: Bool,
                          query: TsundocListQuery) -> AnyView
}
