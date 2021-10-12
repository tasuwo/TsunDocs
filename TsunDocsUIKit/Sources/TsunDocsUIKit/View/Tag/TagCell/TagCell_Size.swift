//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public extension TagCell {
    enum Size {
        case normal
        case small

        public var font: Font {
            switch self {
            case .normal:
                return .body

            case .small:
                return .caption2
            }
        }

        public var padding: CGFloat {
            switch self {
            case .normal:
                return 8

            case .small:
                return 4
            }
        }
    }
}
