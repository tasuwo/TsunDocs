//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

enum TsundocInfoViewRootAction: Action {
    case info(TsundocInfoViewAction)
    case tagGrid(TagGridAction)
}

extension TsundocInfoViewRootAction {
    static let mappingToInfo: ActionMapping<Self, TsundocInfoViewAction> = .init(build: {
        .info($0)
    }, get: {
        switch $0 {
        case let .info(action):
            return action

        case let .tagGrid(.delete(tagId)):
            return .deleteTag(tagId)

        default:
            return nil
        }
    })

    static let mappingToTagGrid: ActionMapping<Self, TagGridAction> = .init(build: {
        .tagGrid($0)
    }, get: {
        guard case let .tagGrid(action) = $0 else { return nil }; return action
    })
}
