//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum SharedUrlEditViewAction: Action {
    case onAppear
    case onLoad(URL, WebPageMeta?)
    case onTapSaveButton
    case onTapEditTitleButton
    case onSaveTitle(String)
    case onFailedToLoadUrl
    case onSelectedEmoji(Emoji?)
    case errorConfirmed
    case alertDismissed
}
