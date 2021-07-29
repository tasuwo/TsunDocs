//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

typealias TsundocListDependency = HasTsundocQueryService
    & HasTsundocCommandService
    & HasTagQueryService
    & HasPasteboard

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

        case let .updateTsundocs(tsundocs):
            nextState.tsundocs = tsundocs
            return (nextState, nil)

        case let .delete(offsets):
            let nextState = Self.delete(offsets: offsets, state, dependency)
            return (nextState, nil)

        case let .select(tsundoc):
            nextState.navigation = .browse(tsundoc, isEditing: false)
            return (nextState, nil)

        case let .selectTags(tagIds, tsundocId):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: tsundocId, byReplacingTagsHaving: tagIds)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToUpdateTsundoc(error)
                } catch {
                    return .failedToUpdateTsundoc(nil)
                }
            }
            nextState.modal = nil
            return (nextState, [effect])

        case let .tap(tsundocId, .editInfo):
            guard let tsundoc = state.tsundocs.first(where: { $0.id == tsundocId }) else {
                return (nextState, nil)
            }
            switch state.navigation {
            case let .browse(tsundoc, isEditing: _) where tsundoc.id == tsundocId:
                nextState.navigation = .browse(tsundoc, isEditing: true)

            default:
                nextState.navigation = .edit(tsundoc)
            }
            return (nextState, nil)

        case let .tap(tsundocId, .addTag):
            let tags = dependency.tagQueryService.fetchTags(taggedToTsundocHaving: tsundocId)
                .successValue?
                .map(\.id) ?? [Tag.ID]()
            nextState.modal = .tagAdditionView(tsundocId, Set(tags))
            return (nextState, nil)

        case let .tap(tsundocId, .copyUrl):
            guard let tsundoc = state.tsundocs.first(where: { $0.id == tsundocId }) else {
                return (nextState, nil)
            }
            dependency.pasteboard.set(tsundoc.url.absoluteString)
            return (nextState, nil)

        case let .tap(tsundocId, .delete):
            nextState.alert = .confirmation(.delete(tsundocId))
            return (nextState, nil)

        case .failedToDeleteTsundoc:
            nextState.alert = .plain(.failedToDelete)
            return (nextState, nil)

        case .failedToUpdateTsundoc:
            nextState.alert = .plain(.failedToUpdate)
            return (nextState, nil)

        case .dismissModal:
            nextState.modal = nil
            return (nextState, nil)

        case let .alert(.confirmedToDelete(tsundocId)):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.deleteTsundoc(having: tsundocId)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToDeleteTsundoc(error)
                } catch {
                    return .failedToDeleteTsundoc(nil)
                }
            }
            return (nextState, [effect])

        case .alert(.dismissed):
            nextState.alert = nil
            return (nextState, nil)

        case let .navigation(.deactivated(destination)):
            switch destination {
            case .edit, .browse:
                nextState.navigation = nil

            case .browseAndEdit:
                switch state.navigation {
                case let .browse(tsundoc, isEditing: _):
                    nextState.navigation = .browse(tsundoc, isEditing: false)

                default:
                    nextState.navigation = nil
                }
            }
            return (nextState, nil)
        }
    }
}

// MARK: - Preparation

extension TsundocListReducer {
    private static func prepareQueryEffects(_ state: State, _ dependency: Dependency) -> (State, [Effect<Action>]) {
        var nextState = state

        let entities: AnyObservedEntityArray<Tsundoc>

        switch state.query {
        case .all:
            switch dependency.tsundocQueryService.queryAllTsundocs() {
            case let .success(result):
                entities = result

            case .failure:
                fatalError("Failed to load entities.")
            }

        case let .tagged(tagId):
            switch dependency.tsundocQueryService.queryTsundocs(tagged: tagId) {
            case let .success(result):
                entities = result

            case .failure:
                fatalError("Failed to load entities.")
            }
        }

        let tsundocsStream = entities.values
            .catch { _ in Just([]) }
            .map { Action.updateTsundocs($0) as Action? }
        let tsundocsEffect = AnimatingEffect(tsundocsStream, underlying: entities)

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
            nextState.alert = .plain(.failedToDelete)
            return nextState
        }

        nextState.tsundocs.remove(atOffsets: offsets)

        return nextState
    }
}
