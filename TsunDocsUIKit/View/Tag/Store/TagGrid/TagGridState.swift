//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TagGridState: Equatable {
    public enum Alert: Equatable {
        public enum Confirmation: Equatable {
            case delete(title: String, action: String)
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
         configuration: TagGridConfiguration)
    {
        self.tags = tags
        self.configuration = configuration
    }
}

extension TagGridState {
    var isPresentingConfirmation: Bool {
        guard case .confirmation = alert else { return false }
        return true
    }

    var titleForConfirmationToDelete: String? {
        guard case let .confirmation(.delete(title: title, action: _)) = alert else { return nil }
        return title
    }

    var actionForConfirmationToDelete: String? {
        guard case let .confirmation(.delete(title: _, action: action)) = alert else { return nil }
        return action
    }
}
