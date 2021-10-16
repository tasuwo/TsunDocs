//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagControlAction: Action {
    case onAppear
    case tagsUpdated([Tag])
    case didTapAddButton
    case didSaveTag(String)
    case failedToSaveTag(CommandServiceError?)
    case alertDismissed
}
