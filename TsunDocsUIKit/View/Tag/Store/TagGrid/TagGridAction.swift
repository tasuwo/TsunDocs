//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagGridAction: Action {
    public enum MenuItem {
        case copy
        case rename
        case delete
    }

    case selected(Tag.ID)
    case deleted(Tag.ID)
    case tappedMenu(Tag.ID, MenuItem)
}
