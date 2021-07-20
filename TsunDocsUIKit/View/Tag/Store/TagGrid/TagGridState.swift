//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagGridState: Equatable {
    public enum Alert: Equatable {
        public enum Confirmation: Equatable {
            case delete(Tag.ID, title: String, action: String)
        }

        case confirmation(Confirmation)
    }

    public let tags: [Tag]
    public let configuration: TagGridConfiguration

    public var alert: Alert?
    public var selectedIds: Set<Tag.ID> = .init()
}

public extension TagGridState {
    init(tags: [Tag],
         configuration: TagGridConfiguration,
         alert: Alert?)
    {
        self.tags = tags
        self.configuration = configuration
        self.alert = alert
    }
}

extension TagGridState {
    var deletingTagId: Tag.ID? {
        guard case let .confirmation(.delete(tagId, title: _, action: _)) = alert else { return nil }
        return tagId
    }

    var titleForConfirmationToDelete: String {
        guard case let .confirmation(.delete(_, title: title, action: _)) = alert else { return "" }
        return title
    }

    var actionForConfirmationToDelete: String {
        guard case let .confirmation(.delete(_, title: _, action: action)) = alert else { return "" }
        return action
    }
}
