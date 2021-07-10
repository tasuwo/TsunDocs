//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagSelectionState: Equatable {
    var tags: [Tag]
    var selectedIds: Set<Tag.ID> = .init()

    let allowsSelection: Bool
    let allowsMultipleSelection: Bool
}

extension TagSelectionState {
    init(tags: [Tag],
         allowsSelection: Bool = false,
         allowsMultipleSelection: Bool = false)
    {
        self.tags = tags
        self.allowsSelection = allowsSelection
        self.allowsMultipleSelection = allowsMultipleSelection
    }
}
