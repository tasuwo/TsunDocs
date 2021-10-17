//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public typealias SearchableFilterDepenency = HasNop

public struct SearchableFilterReducer<Item: Searchable>: Reducer {
    public typealias Dependency = SearchableFilterDepenency
    public typealias State = SearchableFilterState<Item>
    public typealias Action = SearchableFilterAction<Item>

    // MARK: - Initializer

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case let .updateItems(items):
            nextState.items = items

            guard let lastHandledQuery = state.lastHandledQuery else {
                nextState.filteredIds = Set(items.map(\.id))
                return (nextState, .none)
            }

            let displayItems = nextState.storage.perform(query: lastHandledQuery, to: nextState.items)
            nextState.filteredIds = Set(displayItems.map(\.id))

            return (nextState, .none)

        case let .updateQuery(query):
            nextState.lastHandledQuery = query
            let displayItems = nextState.storage.perform(query: query, to: nextState.items)
            nextState.filteredIds = Set(displayItems.map(\.id))
            return (nextState, .none)
        }
    }
}
