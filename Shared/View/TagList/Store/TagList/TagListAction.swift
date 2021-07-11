//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

enum TagListAction: Action {
    case grid(TagGridAction)
    case control(TagListControlAction)
}

extension TagListAction {
    static let mappingToGird: ActionMapping<Self, TagGridAction> = .init(build: {
        .grid($0)
    }, get: {
        guard case let .grid(action) = $0 else { return nil }; return action
    })

    static let mappingToControl: ActionMapping<Self, TagListControlAction> = .init(build: {
        .control($0)
    }, get: {
        guard case let .control(action) = $0 else { return nil }; return action
    })
}
