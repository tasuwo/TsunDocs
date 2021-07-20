//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TagListControlAction: Action {
    enum MenuItem {
        case copy
        case rename
        case delete
    }

    enum AlertAction {
        case updatedTitle(String)
        case confirmedToDelete(Tag.ID)
        case dismissed
    }

    case onAppear
    case queryUpdated(String)
    case tagsUpdated([Tag])
    case didTapAddButton
    case didSaveTag(String)
    case didTapMenu(Tag.ID, MenuItem)
    case failedToSaveTag(CommandServiceError?)
    case failedToDeleteTag(CommandServiceError?)
    case failedToUpdateTag(CommandServiceError?)
    case alert(AlertAction)
    case showDeleteConfirmation(Tag.ID, title: String, action: String)
}
