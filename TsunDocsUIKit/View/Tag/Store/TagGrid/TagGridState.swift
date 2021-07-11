//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagGridState: Equatable {
    public let tags: [Tag]
    public let configuration: TagGridConfiguration

    public var selectedIds: Set<Tag.ID> = .init()
}

public extension TagGridState {
    init(tags: [Tag],
         configuration: TagGridConfiguration)
    {
        self.tags = tags
        self.configuration = configuration
    }
}
