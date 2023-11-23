//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TagMultiSelectionSheetBuilderKey: EnvironmentKey {
    struct Builder: TagMultiSelectionSheetBuildable {
        func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> AnyView {
            assertionFailure("Not Implemented")
            return AnyView(EmptyView())
        }
    }

    static let defaultValue: any TagMultiSelectionSheetBuildable = Builder()
}

public extension EnvironmentValues {
    var tagMultiSelectionSheetBuilder: any TagMultiSelectionSheetBuildable {
        get { self[TagMultiSelectionSheetBuilderKey.self] }
        set { self[TagMultiSelectionSheetBuilderKey.self] = newValue }
    }
}
