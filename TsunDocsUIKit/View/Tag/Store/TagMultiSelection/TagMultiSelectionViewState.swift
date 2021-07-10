//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public struct TagMultiSelectionViewState: Equatable {
    var selectionState: TagSelectionState {
        get {
            .init(tags: tags.filter { filteredIds.contains($0.id) },
                  selectedIds: selectedIds,
                  allowsSelection: true,
                  allowsMultipleSelection: true)
        }
        set {
            tags = newValue.tags
            selectedIds = newValue.selectedIds
        }
    }

    var filterState: TagFilterState {
        get {
            .init(tags: tags,
                  filteredIds: filteredIds,
                  storage: storage)
        }
        set {
            tags = newValue.tags
            filteredIds = newValue.filteredIds
            storage = newValue.storage
        }
    }

    // MARK: - Shared

    var tags: [Tag]

    // MARK: - TagSelectionState

    var selectedIds: Set<Tag.ID> = .init()

    // MARK: - TagFitlerState

    var filteredIds: Set<Tag.ID> = .init()
    var storage: SearchableStorage<Tag> = .init()
}

public extension TagMultiSelectionViewState {
    init(tags: [Tag]) {
        self.tags = tags
        self.filteredIds = Set(tags.map(\.id))
    }
}

public extension TagMultiSelectionViewState {
    static let mappingToSelection: StateMapping<Self, TagSelectionState> = .init(keyPath: \Self.selectionState)
    static let mappingToFilter: StateMapping<Self, TagFilterState> = .init(keyPath: \Self.filterState)
}
