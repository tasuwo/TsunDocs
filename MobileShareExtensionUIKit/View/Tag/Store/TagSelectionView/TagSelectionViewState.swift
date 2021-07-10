//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

struct TagSelectionViewState: Equatable {
    var multiSelection: TagMultiSelectionViewState {
        get {
            .init(tags: tags,
                  selectedIds: selectedIds,
                  filteredIds: filteredIds,
                  storage: storage)
        }
        set {
            tags = newValue.tags
            selectedIds = newValue.selectedIds
            filteredIds = newValue.filteredIds
            storage = newValue.storage
        }
    }

    var control: TagControlState {
        get {
            .init(tags: tags,
                  selectedIds: selectedIds,
                  alert: controlAlert,
                  isTagAdditionAlertPresenting: isTagAdditionAlertPresenting)
        }
        set {
            tags = newValue.tags
            selectedIds = newValue.selectedIds
            controlAlert = newValue.alert
            isTagAdditionAlertPresenting = newValue.isTagAdditionAlertPresenting
        }
    }

    // MARK: - Shared

    var tags: [Tag]
    var selectedIds: Set<Tag.ID> = .init()

    // MARK: - TagMultiSelectionViewState

    var filteredIds: Set<Tag.ID> = .init()
    var storage: SearchableStorage<Tag> = .init()

    // MARK: - TagControlState

    var controlAlert: TagControlState.Alert?
    var isTagAdditionAlertPresenting: Bool = false
}

extension TagSelectionViewState {
    static let mappingToMultiSelection: StateMapping<Self, TagMultiSelectionViewState> = .init(keyPath: \.multiSelection)
    static let mappingToControl: StateMapping<Self, TagControlState> = .init(keyPath: \.control)
}
