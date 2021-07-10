//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

struct TagControlState: Equatable {
    enum Alert {
        case failedToAddTag
    }

    var tags: [Tag]
    var selectedIds: Set<Tag.ID>

    var alert: Alert?
    var isTagAdditionAlertPresenting: Bool
}
