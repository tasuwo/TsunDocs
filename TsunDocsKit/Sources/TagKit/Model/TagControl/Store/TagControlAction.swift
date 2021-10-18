//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagControlAction: Action {
    case onAppear
    case updatedTags([Tag])
    case createNewTag(String)
    case deleteTag(Tag.ID)
    case renameTag(Tag.ID, name: String)
    case failedToCreateTag(CommandServiceError?)
    case failedToDeleteTag(CommandServiceError?)
    case failedToRenameTag(CommandServiceError?)
    case alertDismissed
}
