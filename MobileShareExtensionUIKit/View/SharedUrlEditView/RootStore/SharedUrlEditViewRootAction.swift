//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

enum SharedUrlEditViewRootAction: Action {
    case edit(SharedUrlEditViewAction)
    case image(SharedUrlImageAction)
}

extension SharedUrlEditViewRootAction {
    static let mappingToEdit: ActionMapping<Self, SharedUrlEditViewAction> = .init(build: {
        .edit($0)
    }, get: {
        switch $0 {
        case let .edit(action):
            return action
        case let .image(.selectedEmoji(emoji)):
            return .onSelectedEmoji(emoji)
        case .image(.didTapDeleteEmoji):
            return .onSelectedEmoji(nil)
        default:
            return nil
        }
    })

    static let mappingToImage: ActionMapping<Self, SharedUrlImageAction> = .init(build: {
        .image($0)
    }, get: {
        switch $0 {
        case let .image(action):
            return action
        case let .edit(.onLoad(_, meta)):
            return .onLoadImageUrl(meta?.imageUrl)
        default:
            return nil
        }
    })
}
