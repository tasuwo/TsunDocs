//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagMultiSelectionViewAction: Action {
    case tagsUpdated([Tag])
    case grid(TagGridAction)
    case filter(TagFilterAction)
}

public extension TagMultiSelectionViewAction {
    static let mappingToGrid: ActionMapping<Self, TagGridAction> = .init(build: {
        .grid($0)
    }, get: {
        guard case let .grid(action) = $0 else { return nil }; return action
    })

    static let mappingToFilter: ActionMapping<Self, TagFilterAction> = .init(build: {
        .filter($0)
    }, get: {
        switch $0 {
        case let .tagsUpdated(tags):
            return .updateTags(tags)

        case let .filter(action):
            return action

        default:
            return nil
        }
    })
}
