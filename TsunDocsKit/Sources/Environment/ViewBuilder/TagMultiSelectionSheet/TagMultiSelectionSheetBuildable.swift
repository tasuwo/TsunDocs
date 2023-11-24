//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable(typealias: TagMultiSelectionSheet = SampleView)
public protocol TagMultiSelectionSheetBuildable {
    associatedtype TagMultiSelectionSheet: View

    @MainActor
    func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> TagMultiSelectionSheet
}
