//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

enum TagSelectionViewAction: Action {
    case multiSelection(TagMultiSelectionViewAction)
    case control(TagControlAction)
}

extension TagSelectionViewAction {
    static let mappingToMultiSelection: ActionMapping<Self, TagMultiSelectionViewAction> = .init(build: {
        .multiSelection($0)
    }, get: {
        switch $0 {
        case let .control(.tagsUpdated(tags)):
            return .tagsUpdated(tags)

        case let .multiSelection(action):
            return action

        default:
            return nil
        }
    })

    static let mappingToControl: ActionMapping<Self, TagControlAction> = .init(build: {
        .control($0)
    }, get: {
        guard case let .control(action) = $0 else { return nil }; return action
    })
}
