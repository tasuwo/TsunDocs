//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public enum TagCellSize {
    case normal
    case small

    var font: Font {
        switch self {
        case .normal:
            return .body

        case .small:
            return .caption2
        }
    }

    var padding: CGFloat {
        switch self {
        case .normal:
            return 8

        case .small:
            return 4
        }
    }
}
