//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

public struct TagSelectionViewState: Equatable {
    var multiSelectionState: TagMultiSelectionViewState = .init(tags: [])
    var controlState: TagControlState = .init()
}

extension TagSelectionViewState {
    var selectedTags: [Tag] {
        multiSelectionState.tags.filter { multiSelectionState.selectedIds.contains($0.id) }
    }
}

extension TagSelectionViewState {
    init(selectedIds: Set<Tag.ID>) {
        self.multiSelectionState = .init(selectedIds: selectedIds)
    }
}

extension TagSelectionViewState {
    static let mappingToMultiSelection: StateMapping<Self, TagMultiSelectionViewState> = .init(keyPath: \.multiSelectionState)
    static let mappingToControl: StateMapping<Self, TagControlState> = .init(keyPath: \.controlState)
}
