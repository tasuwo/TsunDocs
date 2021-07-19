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
        switch $0 {
        case let .control(action):
            return action

        case let .grid(.tappedMenu(tagId, item)):
            return .didTapMenu(tagId, item.controlAction)

        default:
            return nil
        }
    })
}

private extension TagGridAction.MenuItem {
    var controlAction: TagListControlAction.MenuItem {
        switch self {
        case .copy:
            return .copy

        case .rename:
            return .rename

        case .delete:
            return .delete
        }
    }
}
