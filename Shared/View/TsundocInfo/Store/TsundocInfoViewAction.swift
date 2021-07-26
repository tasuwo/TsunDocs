//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TsundocInfoViewAction: Action {
    case onAppear

    case updateTsundoc(Tsundoc)
    case updateTag([Tag])

    case editTitle(String)
    case editEmoji(Emoji?)
    case editTags([Tag])
    case deleteTag(Tag.ID)

    case failedToLoad
    case failedToUpdate
}
