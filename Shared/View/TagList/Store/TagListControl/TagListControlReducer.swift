//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

typealias TagListControlDependency = HasTagCommandService
    & HasTagQueryService

struct TagListControlReducer: Reducer {
    typealias Dependency = TagListControlDependency
    typealias State = TagListControlState
    typealias Action = TagListControlAction

    // MARK: - Reducer

    func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case .onAppear:
            return Self.prepareQueryEffects(nextState, dependency)

        case let .queryUpdated(query):
            nextState.lastHandledQuery = query
            let displayTags = nextState.storage.perform(query: query, to: nextState.tags)
            nextState.filteredIds = Set(displayTags.map(\.id))
            return (nextState, .none)

        case let .tagsUpdated(tags):
            nextState.tags = tags

            guard let lastHandledQuery = state.lastHandledQuery else {
                nextState.filteredIds = Set(tags.map(\.id))
                return (nextState, .none)
            }

            let displayTags = nextState.storage.perform(query: lastHandledQuery, to: nextState.tags)
            nextState.filteredIds = Set(displayTags.map(\.id))

            return (nextState, .none)

        case .didTapAddButton:
            nextState.isTagAdditionAlertPresenting = true
            return (nextState, .none)

        case let .didSaveTag(tagName):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.createAndCommitTag(by: .init(name: tagName))
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToSaveTag(error)
                } catch {
                    return .failedToSaveTag(nil)
                }
            }
            return (nextState, [effect])

        case .failedToSaveTag:
            nextState.alert = .failedToAddTag
            return (nextState, .none)

        case .alertDismissed:
            nextState.isTagAdditionAlertPresenting = false
            return (nextState, .none)
        }
    }
}

// MARK: - Preparation

extension TagListControlReducer {
    private static func prepareQueryEffects(_ state: State, _ dependency: Dependency) -> (State, [Effect<Action>]) {
        var nextState = state

        let entities: AnyObservedEntityArray<Tag>
        switch dependency.tagQueryService.queryAllTags() {
        case let .success(result):
            entities = result

        case .failure:
            fatalError("Failed to load entities.")
        }

        let tagsStream = entities.values
            .catch { _ in Just([]) }
            .map { Action.tagsUpdated($0) as Action? }
        let tagsEffect = Effect(tagsStream, underlying: entities)

        nextState.tags = entities.values.value

        return (nextState, [tagsEffect])
    }
}
