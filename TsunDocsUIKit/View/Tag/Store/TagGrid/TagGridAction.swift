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

    public enum AlertAction {
        case confirmedToDelete(Tag.ID)
        case dismissed
    }

    case selected(Tag.ID)
    case deleted(Tag.ID)
    case tappedMenu(Tag.ID, MenuItem)
    case alert(AlertAction)
    case showDeleteConfirmation(Tag.ID, title: String, action: String)
}
