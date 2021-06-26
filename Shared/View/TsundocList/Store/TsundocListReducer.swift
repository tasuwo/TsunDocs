//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

typealias TsundocListDependency = HasTsundocQueryService
    & HasTsundocCommandService

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

        case let .onDelete(offsets):
            let nextState = Self.delete(offsets: offsets, state, dependency)
            return (nextState, nil)

        case let .select(tsundoc):
            nextState.modal = .safariView(tsundoc)
            return (nextState, nil)

        case .modalDismissed:
            nextState.modal = nil
            return (nextState, nil)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, nil)
        }
    }
}

// MARK: - Preparation

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

// MARK: - Deletion

extension TsundocListReducer {
    private static func delete(offsets: IndexSet, _ state: State, _ dependency: Dependency) -> State {
        var nextState = state

        let targets = offsets
            .filter { state.tsundocs.indices.contains($0) }
            .map { state.tsundocs[$0] }

        var failedToDelete = false
        dependency.tsundocCommandService.perform {
            do {
                try dependency.tsundocCommandService.begin()

                var failures: [CommandServiceError] = []
                targets.forEach {
                    if let failure = dependency.tsundocCommandService.deleteTsundoc(having: $0.id).failureValue {
                        failures.append(failure)
                    }
                }

                guard failures.isEmpty else {
                    try dependency.tsundocCommandService.cancel()
                    failedToDelete = true
                    return
                }

                try dependency.tsundocCommandService.commit()
            } catch {
                failedToDelete = true
            }
        }

        if failedToDelete {
            nextState.alert = .failedToDelete
            return nextState
        }

        nextState.tsundocs.remove(atOffsets: offsets)

        return nextState
    }
}
