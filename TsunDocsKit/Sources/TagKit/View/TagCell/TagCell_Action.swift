//
//  Created by Tasuku Tozawa on 2021/10/12.
//

import struct Domain.Tag
import Foundation

public extension TagCell {
    enum Action {
        case select(Tag.ID)
        case delete(Tag.ID)
    }
}
