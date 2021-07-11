//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public enum TagCellStatus {
    case `default`
    case selected
    case deletable

    var isSelected: Bool {
        switch self {
        case .selected:
            return true

        default:
            return false
        }
    }

    var isDeletable: Bool {
        switch self {
        case .deletable:
            return true

        default:
            return false
        }
    }
}
