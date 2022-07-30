//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag
import Foundation

public extension TagGrid {
    enum Action {
        case select(tagId: Tag.ID)
        case delete(tagId: Tag.ID)
        case copy(tagId: Tag.ID)
        case rename(tagId: Tag.ID, name: String)
    }
}
