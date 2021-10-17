//
//  Created by Tasuku Tozawa on 2021/10/12.
//

import Foundation

public extension TagCell {
    enum Action {
        case select(UUID)
        case delete(UUID)
    }
}
