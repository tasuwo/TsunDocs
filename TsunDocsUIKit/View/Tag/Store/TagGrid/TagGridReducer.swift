//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagGridDependency = HasNop

public struct TagGridReducer: Reducer {
    public typealias Dependency = TagGridDependency
    public typealias State = TagGridState
    public typealias Action = TagGridAction

    // MARK: - Initializer

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case let .select(tagId):
            switch state.configuration.style {
            case .selectable(.single):
                nextState.selectedIds = state.selectedIds.contains(tagId)
                    ? .init()
                    : Set([tagId])

            case .selectable(.multiple):
                nextState.selectedIds = state.selectedIds.contains(tagId)
                    ? state.selectedIds.subtracting(Set([tagId]))
                    : state.selectedIds.union(Set([tagId]))

            default: ()
            }

            return (nextState, .none)

        case .delete:
            // NOP
            return (nextState, .none)

        case .tap:
            // NOP
            return (nextState, .none)

        case .alert(.confirmedToDelete):
            nextState.alert = nil
            return (nextState, .none)

        case .alert(.dismissed):
            nextState.alert = nil
            return (nextState, .none)

        case let .present(.deleteConfirmation(tagId, title: title, action: action)):
            nextState.alert = .confirmation(.delete(tagId, title: title, action: action))
            return (nextState, .none)
        }
    }
}
