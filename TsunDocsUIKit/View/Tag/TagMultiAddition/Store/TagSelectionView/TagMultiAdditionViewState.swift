//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public struct TagMultiAdditionViewState: Equatable {
    var multiSelectionState: TagMultiSelectionViewState = .init(tags: [])
    var controlState: TagControlState = .init()
}

extension TagMultiAdditionViewState {
    var selectedTags: [Tag] {
        multiSelectionState.tags.filter { multiSelectionState.selectedIds.contains($0.id) }
    }
}

public extension TagMultiAdditionViewState {
    init(selectedIds: Set<Tag.ID>) {
        self.multiSelectionState = .init(selectedIds: selectedIds)
    }
}

extension TagMultiAdditionViewState {
    static let mappingToMultiSelection: StateMapping<Self, TagMultiSelectionViewState> = .init(keyPath: \.multiSelectionState)
    static let mappingToControl: StateMapping<Self, TagControlState> = .init(keyPath: \.controlState)
}
