//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

typealias TsundocListDependency = Void

struct TsundocListReducer: Reducer {
    typealias Dependency = TsundocListDependency
    typealias State = TsundocListState
    typealias Action = TsundocListAction

    // MARK: - Reducer

    func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case let .select(tsundoc):
            nextState.modal = .safariView(tsundoc)
            return (nextState, nil)

        case .modalDismissed:
            nextState.modal = nil
            return (nextState, nil)
        }
    }
}
