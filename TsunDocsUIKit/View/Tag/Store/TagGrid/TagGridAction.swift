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

    public enum PresentAction {
        case deleteConfirmation(Tag.ID, title: String, action: String)
    }

    case select(Tag.ID)
    case delete(Tag.ID)
    case tap(Tag.ID, MenuItem)
    case alert(AlertAction)
    case present(PresentAction)
}
