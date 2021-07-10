//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagFilterDependency = Void

public struct TagFilterReducer: Reducer {
    public typealias Dependency = TagFilterDependency
    public typealias State = TagFilterState
    public typealias Action = TagFilterAction

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case let .queryUpdated(query):
            let displayTags = nextState.storage.perform(query: query, to: nextState.tags)
            nextState.filteredIds = Set(displayTags.map(\.id))
            return (nextState, .none)
        }
    }
}
