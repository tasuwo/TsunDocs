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

    enum NavigationAction {
        case deactivated
    }

    enum PresentAction {
        case deleteConfirmation(Tag.ID, title: String, action: String)
    }

    case onAppear
    case updateQuery(String)
    case updateTags([Tag])
    case addNewTag
    case saveNewTag(String)
    case select(Tag.ID)
    case tap(Tag.ID, MenuItem)
    case failedToSaveTag(CommandServiceError?)
    case failedToDeleteTag(CommandServiceError?)
    case failedToUpdateTag(CommandServiceError?)
    case alert(AlertAction)
    case navigation(NavigationAction)
    case present(PresentAction)
}
