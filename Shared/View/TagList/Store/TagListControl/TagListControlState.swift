//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

struct TagListControlState: Equatable {
    enum Alert: Equatable {
        case failedToAddTag
    }

    var tags: [Tag] = []
    var lastHandledQuery: String?
    var filteredIds: Set<Tag.ID> = .init()
    var storage: SearchableStorage<Tag> = .init()
    var alert: Alert?
    var isTagAdditionAlertPresenting = false
}
