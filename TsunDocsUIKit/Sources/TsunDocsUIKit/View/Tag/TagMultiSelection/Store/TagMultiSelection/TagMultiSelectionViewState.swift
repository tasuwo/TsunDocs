//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public struct TagMultiSelectionViewState: Equatable {
    var gridState: TagGridState {
        get {
            .init(tags: tags.filter { filteredIds.contains($0.id) },
                  configuration: .init(.selectable(.multiple)),
                  selectedIds: selectedIds)
        }
        set {
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

    public var tags: [Tag]

    // MARK: - TagGridState

    public var selectedIds: Set<Tag.ID> = .init()

    // MARK: - TagFitlerState

    public var filteredIds: Set<Tag.ID> = .init()
    public var storage: SearchableStorage<Tag> = .init()

    // MARK: - Initializers

    public init(tags: [Tag] = [],
                selectedIds: Set<Tag.ID> = .init(),
                filteredIds: Set<Tag.ID> = .init(),
                storage: SearchableStorage<Tag> = .init())
    {
        self.tags = tags
        self.selectedIds = selectedIds
        self.filteredIds = filteredIds
        self.storage = storage
    }
}

public extension TagMultiSelectionViewState {
    init(tags: [Tag]) {
        self.tags = tags
        self.filteredIds = Set(tags.map(\.id))
    }
}

public extension TagMultiSelectionViewState {
    static let mappingToGrid: StateMapping<Self, TagGridState> = .init(keyPath: \Self.gridState)
    static let mappingToFilter: StateMapping<Self, TagFilterState> = .init(keyPath: \Self.filterState)
}
