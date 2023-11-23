//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import SwiftUI
import TagMultiSelectionFeature

extension DependencyContainer: TagMultiSelectionSheetBuildable {
    // MARK: - TagMultiSelectionSheetBuildable

    public typealias TagMultiSelectionSheet = TagMultiSelectionFeature.TagMultiSelectionSheet

    public func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> TagMultiSelectionSheet {
        let store = Store(initialState: TagMultiSelectionState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: TagMultiSelectionReducer())
        return TagMultiSelectionSheet(store: ViewStore(store: store), onDone: onDone)
    }
}
