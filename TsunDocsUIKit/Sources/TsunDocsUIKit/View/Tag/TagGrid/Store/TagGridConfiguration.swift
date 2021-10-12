//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public struct TagGridConfiguration: Equatable {
    public enum SelectionStyle: Equatable {
        case single
        case multiple
    }

    public enum Style: Equatable {
        case `default`
        case deletable
        case selectable(SelectionStyle)
    }

    // MARK: - Properties

    public let style: Style
    public let size: TagCell.Size
    public let isEnabledMenu: Bool

    // MARK: - Initializers

    public init(_ style: Style,
                size: TagCell.Size = .normal,
                isEnabledMenu: Bool = false)
    {
        self.style = style
        self.size = size
        self.isEnabledMenu = isEnabledMenu
    }
}
