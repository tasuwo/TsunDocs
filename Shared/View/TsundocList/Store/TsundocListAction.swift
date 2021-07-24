//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TsundocListAction {
    enum MenuItem {
        case editInfo
        case addTag
        case copyUrl
        case delete
    }

    enum AlertAction {
        case confirmedToDelete(Tsundoc.ID)
        case dismissed
    }

    case onAppear
    case updateTsundocs([Tsundoc])
    case delete(IndexSet)
    case select(Tsundoc)
    case selectTags(Set<Tag.ID>, Tsundoc.ID)
    case tap(Tsundoc.ID, MenuItem)
    case failedToDeleteTsundoc(CommandServiceError?)
    case failedToUpdateTsundoc(CommandServiceError?)
    case dismissModal
    case alert(AlertAction)
}

extension TsundocListAction: Action {}
