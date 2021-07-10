//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TagControlAction: Action {
    case onAppear
    case tagsUpdated([Tag])
    case didTapAddButton
    case didTapDoneButton
    case didSaveTag(String)
    case alertDismissed
}
