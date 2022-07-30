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

    public enum NavigationAction {
        public enum Destination {
            case edit
            case browse
            case browseAndEdit
        }

        case deactivated(Destination)
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
    case navigation(NavigationAction)
}

extension TsundocListAction: Action {}
