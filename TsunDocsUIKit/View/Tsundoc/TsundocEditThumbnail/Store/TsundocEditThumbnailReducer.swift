//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TsundocEditThumbnailDependency = HasNop

public struct TsundocEditThumbnailReducer: Reducer {
    public typealias Dependency = TsundocEditThumbnailDependency
    public typealias State = TsundocEditThumbnailState
    public typealias Action = TsundocEditThumbnailAction

    // MARK: - Initializers

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case .didTapDeleteEmoji:
            nextState.selectedEmoji = nil
            return (nextState, .none)

        case let .selectedEmoji(emoji):
            nextState.selectedEmoji = emoji
            return (nextState, .none)

        case let .updatedThumbnail(status):
            nextState.thumbnailLoadingStatus = status
            return (nextState, .none)
        }
    }
}
