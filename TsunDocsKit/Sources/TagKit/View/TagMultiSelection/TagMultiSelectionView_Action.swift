//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag

public extension TagMultiSelectionView {
    enum Action {
        case done(selected: Set<Tag.ID>)
        case addNewTag(name: String)
    }
}
