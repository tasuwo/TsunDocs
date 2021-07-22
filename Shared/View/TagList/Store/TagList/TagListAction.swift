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
        switch $0 {
        case let .grid(action):
            return action

        case let .control(.present(.deleteConfirmation(tagId, title: title, action: action))):
            return .present(.deleteConfirmation(tagId, title: title, action: action))

        default:
            return nil
        }
    })

    static let mappingToControl: ActionMapping<Self, TagListControlAction> = .init(build: {
        .control($0)
    }, get: {
        switch $0 {
        case let .control(action):
            return action

        case let .grid(.select(tagId)):
            return .select(tagId)

        case let .grid(.tap(tagId, item)):
            return .tap(tagId, item.controlAction)

        case let .grid(.alert(.confirmedToDelete(tagId))):
            return .alert(.confirmedToDelete(tagId))

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
