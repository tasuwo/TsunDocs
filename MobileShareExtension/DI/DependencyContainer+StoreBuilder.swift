//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

extension DependencyContainer: TagMultiAdditionViewStoreBuildable {
    // MARK: - TagMultiAdditionViewStoreBuildable

    func buildTagMultiAdditionViewStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiAdditionViewState, TagMultiAdditionViewAction, TagMultiAdditionViewDependency> {
        let store = Store(initialState: TagMultiAdditionViewState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: tagMultiAdditionViewReducer)
        return ViewStore(store: store)
    }
}
