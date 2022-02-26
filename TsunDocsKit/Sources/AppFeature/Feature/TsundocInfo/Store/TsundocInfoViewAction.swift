//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsundocList

enum TsundocInfoViewAction: Action {
    case onAppear

    case updateTsundoc(Tsundoc)
    case updateTag([Tag])

    case editTitle(String)
    case editEmojiInfo(EmojiInfo?)
    case editTags([Tag])
    case deleteTag(Tag.ID)

    case failedToLoad
    case failedToUpdate
}
