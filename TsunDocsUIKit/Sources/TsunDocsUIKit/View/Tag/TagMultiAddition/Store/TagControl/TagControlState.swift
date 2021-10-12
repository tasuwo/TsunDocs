//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagControlState: Equatable {
    enum Alert {
        case failedToAddTag
    }

    var tags: [Tag] = []
    var selectedIds: Set<Tag.ID> = .init()

    var alert: Alert?
    var isTagAdditionAlertPresenting = false
}