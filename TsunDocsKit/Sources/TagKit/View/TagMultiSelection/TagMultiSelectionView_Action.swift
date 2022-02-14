//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag

public extension TagMultiSelectionView {
    enum Action {
        case done
        case addNewTag(name: String)
    }
}
