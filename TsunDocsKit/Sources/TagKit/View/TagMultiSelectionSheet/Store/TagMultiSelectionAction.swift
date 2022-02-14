//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagMultiSelectionAction: Action {
    case onAppear
    case updatedTags([Tag])
    case updatedSelectedTags(Set<Tag.ID>)
    case createNewTag(String)
    case createdNewTag(Tag.ID)
    case failedToCreateTag(CommandServiceError?)
    case alertDismissed
}
