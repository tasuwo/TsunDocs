//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagSelectionViewState: Equatable {
    var tags: EntitiesSnapshot<Tag>
    var storage: SearchableStorage<Tag> = .init()
}

extension TagSelectionViewState {
    init(tags: [Tag]) {
        self.tags = EntitiesSnapshot(tags)
    }
}
