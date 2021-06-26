//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

enum SharedUrlEditViewAction {
    case onAppear
    case onLoad(URL, SharedUrlMetaResolver.SharedUrlMeta?)
    case onTapButton
    case onFailedToLoadUrl
    case errorConfirmed
    case alertDismissed
}

extension SharedUrlEditViewAction: Action {}
