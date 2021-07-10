//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagSelectionViewDependency = Void

public struct TagSelectionViewReducer: Reducer {
    public typealias Dependency = TagSelectionViewDependency
    public typealias State = TagSelectionViewState
    public typealias Action = TagSelectionViewAction

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case let .selected(tagId):
            nextState.tags = state.tags.selecting(id: tagId)
            return (nextState, .none)

        case let .deselected(tagId):
            nextState.tags = state.tags.deselecting(id: tagId)
            return (nextState, .none)

        case let .queryUpdated(query):
            let displayTags = nextState.storage.perform(query: query, to: nextState.tags.orderedEntities())
            nextState.tags = nextState.tags.updating(filteredIds: Set(displayTags.map(\.id)))
            return (nextState, .none)
        }
    }
}
