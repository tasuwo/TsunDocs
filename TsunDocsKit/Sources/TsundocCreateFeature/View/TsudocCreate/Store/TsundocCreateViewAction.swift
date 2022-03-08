//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Foundation
import TsundocList

public enum TsundocCreateViewAction: Action {
    case onAppear
    case onLoad(WebPageMeta?)
    case onTapSaveButton
    case succeededToSave
    case failedToSave
    case onSaveTitle(String)
    case onSelectedEmojiInfo(EmojiInfo?)
    case onSelectedTags([Tag])
    case onDeleteTag(Tag.ID)
    case onToggleUnread(Bool)
    case errorConfirmed
    case alertDismissed
}
