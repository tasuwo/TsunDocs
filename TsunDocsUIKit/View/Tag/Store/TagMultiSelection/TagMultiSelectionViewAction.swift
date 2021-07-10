//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagMultiSelectionViewAction: Action {
    case tagsUpdated([Tag])
    case selection(TagSelectionAction)
    case filter(TagFilterAction)
}

public extension TagMultiSelectionViewAction {
    static let mappingToSelection: ActionMapping<Self, TagSelectionAction> = .init(build: {
        .selection($0)
    }, get: {
        guard case let .selection(action) = $0 else { return nil }; return action
    })

    static let mappingToFilter: ActionMapping<Self, TagFilterAction> = .init(build: {
        .filter($0)
    }, get: {
        switch $0 {
        case let .tagsUpdated(tags):
            return .tagsUpdated(tags)

        case let .filter(action):
            return action

        default:
            return nil
        }
    })
}
