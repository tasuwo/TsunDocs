//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Foundation
import UIComponent

public enum TsundocListAction {
    public enum MenuItem {
        case editInfo
        case addTag
        case addEmoji
        case copyUrl
        case delete
    }

    public enum AlertAction {
        case confirmedToDelete(Tsundoc.ID)
        case createTsundoc(URL)
        case dismissed
    }

    case onAppear
    case updateTsundocs([Tsundoc])
    case updateEmojiInfo(EmojiInfo, Tsundoc.ID)
    case delete(Tsundoc)
    case toggleUnread(Tsundoc)
    case select(Tsundoc)
    case selectTags(Set<Tag.ID>, Tsundoc.ID)
    case tap(Tsundoc.ID, MenuItem)
    case createTsundoc
    case activateTsundocFilter(TsundocFilter)
    case deactivateTsundocFilter
    case failedToDeleteTsundoc(CommandServiceError?)
    case failedToUpdateTsundoc(CommandServiceError?)
    case dismissModal
    case alert(AlertAction)
}

extension TsundocListAction: Action {}
