//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagMultiSelectionState: Equatable {
    public enum Alert {
        case failedToCreateTag
    }

    // MARK: - Properties

    public var tags: [Tag] = []
    public var alert: Alert?

    public var selectedIds: Set<Tag.ID>

    // MARK: - Initializers

    public init(tags: [Tag] = [], selectedIds: Set<Tag.ID> = .init(), alert: Alert? = nil) {
        self.tags = tags
        self.selectedIds = selectedIds
        self.alert = alert
    }
}

public extension TagMultiSelectionState {
    var selectedTags: [Tag] { tags.filter { selectedIds.contains($0.id) } }
    var isFailedToCreateTagAlertPresenting: Bool { alert == .failedToCreateTag }
}
