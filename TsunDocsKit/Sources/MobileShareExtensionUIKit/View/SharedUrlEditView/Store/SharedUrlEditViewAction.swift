//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Foundation
import TsundocList

public enum SharedUrlEditViewAction: Action {
    case onAppear
    case onLoad(URL, WebPageMeta?)
    case onTapSaveButton
    case succeededToSave
    case failedToSave
    case onSaveTitle(String)
    case onFailedToLoadUrl
    case onSelectedEmojiInfo(EmojiInfo?)
    case onSelectedTags([Tag])
    case onDeleteTag(Tag.ID)
    case errorConfirmed
    case alertDismissed
}
