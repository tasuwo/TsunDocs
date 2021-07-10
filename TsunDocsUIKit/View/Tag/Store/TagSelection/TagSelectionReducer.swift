//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagSelectionDependency = Void

public struct TagSelectionReducer: Reducer {
    public typealias Dependency = TagSelectionDependency
    public typealias State = TagSelectionState
    public typealias Action = TagSelectionAction

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case let .selected(tagId):
            guard state.allowsSelection else {
                return (nextState, .none)
            }

            if state.selectedIds.contains(tagId) {
                nextState.selectedIds = state.allowsMultipleSelection
                    ? state.selectedIds.subtracting(Set([tagId]))
                    : .init()
            } else {
                nextState.selectedIds = state.allowsMultipleSelection
                    ? state.selectedIds.union(Set([tagId]))
                    : Set([tagId])
            }

            return (nextState, .none)
        }
    }
}
