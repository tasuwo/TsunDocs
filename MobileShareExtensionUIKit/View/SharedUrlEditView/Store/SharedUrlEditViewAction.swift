//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum SharedUrlEditViewAction: Action {
    case onAppear
    case onLoad(URL, WebPageMeta?)
    case onTapSaveButton
    case succeededToSave
    case failedToSave
    case onTapEditTitleButton
    case onTapEditTagButton
    case onSaveTitle(String)
    case onFailedToLoadUrl
    case onSelectedEmoji(Emoji?)
    case onSelectedTags([Tag])
    case onDeleteTag(Tag.ID)
    case errorConfirmed
    case alertDismissed
}
