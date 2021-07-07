//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum SharedUrlEditViewAction {
    case onAppear
    case onLoad(URL, WebPageMeta?)
    case onTapButton
    case onFailedToLoadUrl
    case errorConfirmed
    case alertDismissed
}

extension SharedUrlEditViewAction: Action {}
