//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public enum SharedUrlEditViewRootAction: Action {
    case edit(SharedUrlEditViewAction)
    case image(SharedUrlImageAction)
}

public extension SharedUrlEditViewRootAction {
    static let mappingToEdit: ActionMapping<Self, SharedUrlEditViewAction> = .init(build: {
        .edit($0)
    }, get: {
        guard case let .edit(action) = $0 else { return nil }; return action
    })

    static let mappingToImage: ActionMapping<Self, SharedUrlImageAction> = .init(build: {
        .image($0)
    }, get: {
        guard case let .image(action) = $0 else { return nil }; return action
    })
}
