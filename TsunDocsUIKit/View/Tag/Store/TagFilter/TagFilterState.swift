//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagFilterState: Equatable {
    var tags: [Tag]
    var filteredIds: Set<Tag.ID> = .init()
    var storage: SearchableStorage<Tag> = .init()
}

extension TagFilterState {
    init(tags: [Tag]) {
        self.tags = tags
        self.filteredIds = Set(tags.map(\.id))
    }
}
