//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TagListControlAction: Action {
    case onAppear
    case queryUpdated(String)
    case tagsUpdated([Tag])
    case didTapAddButton
    case didSaveTag(String)
    case failedToSaveTag(CommandServiceError?)
    case alertDismissed
}
