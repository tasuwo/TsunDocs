//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable
public protocol TagMultiSelectionSheetBuildable {
    @MainActor
    @ViewBuilder
    func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> AnyView
}
