//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

typealias TsundocListDependency = HasTsundocQueryService

struct TsundocListReducer: Reducer {
    typealias Dependency = TsundocListDependency
    typealias State = TsundocListState
    typealias Action = TsundocListAction

    // MARK: - Reducer

    func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case .onAppear:
            return Self.prepareQueryEffects(nextState, dependency)

        case let .onUpdate(tsundocs):
            nextState.tsundocs = tsundocs
            return (nextState, nil)

        case let .select(tsundoc):
            nextState.modal = .safariView(tsundoc)
            return (nextState, nil)

        case .modalDismissed:
            nextState.modal = nil
            return (nextState, nil)
        }
    }
}

extension TsundocListReducer {
    private static func prepareQueryEffects(_ state: State, _ dependency: Dependency) -> (State, [Effect<Action>]) {
        var nextState = state

        let entities: AnyObservedEntityArray<Tsundoc>
        switch dependency.tsundocQueryService.queryAllTsundocs() {
        case let .success(result):
            entities = result

        case .failure:
            fatalError("Failed to load entities.")
        }

        let tsundocsStream = entities.values
            .catch { _ in Just([]) }
            .map { Action.onUpdate($0) as Action? }
        let tsundocsEffect = Effect(tsundocsStream, underlying: entities)

        nextState.tsundocs = entities.values.value

        return (nextState, [tsundocsEffect])
    }
}
