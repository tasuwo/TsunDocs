//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias SharedUrlImageDependency = HasNop

public struct SharedUrlImageReducer: Reducer {
    public typealias Dependency = SharedUrlImageDependency
    public typealias State = SharedUrlImageState
    public typealias Action = SharedUrlImageAction

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case let .onLoadImageUrl(url):
            nextState.imageUrl = url
            return (nextState, .none)

        case .didTapSelectEmoji:
            nextState.isSelectingEmoji = true
            return (nextState, .none)

        case .didTapDeleteEmoji:
            nextState.selectedEmoji = nil
            return (nextState, .none)

        case let .selectedEmoji(emoji):
            nextState.selectedEmoji = emoji
            nextState.isSelectingEmoji = false
            return (nextState, .none)

        case let .updatedThumbnail(status):
            nextState.thumbnailLoadingStatus = status
            return (nextState, .none)

        case let .updatedEmojiSheet(isPresenting: isPresenting):
            nextState.isSelectingEmoji = isPresenting
            return (nextState, .none)
        }
    }
}
