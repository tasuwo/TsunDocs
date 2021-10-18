//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagControlAction: Action {
    case onAppear
    case updatedTags([Tag])
    case createNewTag(String)
    case failedToCreateTag(CommandServiceError?)
    case alertDismissed
}
