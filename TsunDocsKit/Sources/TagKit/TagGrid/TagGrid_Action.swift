//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

public extension TagGrid {
    enum Action {
        case select(tagId: UUID)
        case delete(tagId: UUID)
        case copy(tagId: UUID)
        case rename(tagId: UUID, name: String)
    }
}
