//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public extension TagCell {
    enum Status {
        case `default`
        case selected
        case deletable

        public var isSelected: Bool {
            switch self {
            case .selected:
                return true

            default:
                return false
            }
        }

        public var isDeletable: Bool {
            switch self {
            case .deletable:
                return true

            default:
                return false
            }
        }
    }
}
