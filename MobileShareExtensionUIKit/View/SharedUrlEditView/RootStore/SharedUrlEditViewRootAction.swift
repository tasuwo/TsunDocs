//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

public enum SharedUrlEditViewRootAction: Action {
    case edit(SharedUrlEditViewAction)
    case image(SharedUrlImageAction)
    case tagGrid(TagGridAction)
}

public extension SharedUrlEditViewRootAction {
    static let mappingToEdit: ActionMapping<Self, SharedUrlEditViewAction> = .init(build: {
        .edit($0)
    }, get: {
        switch $0 {
        case let .edit(action):
            return action

        case let .tagGrid(.delete(tagId)):
            return .onDeleteTag(tagId)

        default:
            return nil
        }
    })

    static let mappingToImage: ActionMapping<Self, SharedUrlImageAction> = .init(build: {
        .image($0)
    }, get: {
        guard case let .image(action) = $0 else { return nil }; return action
    })

    static let mappingToTagGrid: ActionMapping<Self, TagGridAction> = .init(build: {
        .tagGrid($0)
    }, get: {
        guard case let .tagGrid(action) = $0 else { return nil }; return action
    })
}
