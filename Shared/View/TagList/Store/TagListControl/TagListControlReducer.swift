//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

typealias TagListControlDependency = HasTagCommandService
    & HasTagQueryService
    & HasPasteboard

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

        case let .updateQuery(query):
            nextState.lastHandledQuery = query
            let displayTags = nextState.storage.perform(query: query, to: nextState.tags)
            nextState.filteredIds = Set(displayTags.map(\.id))
            return (nextState, .none)

        case let .updateTags(tags):
            nextState.tags = tags

            guard let lastHandledQuery = state.lastHandledQuery else {
                nextState.filteredIds = Set(tags.map(\.id))
                return (nextState, .none)
            }

            let displayTags = nextState.storage.perform(query: lastHandledQuery, to: nextState.tags)
            nextState.filteredIds = Set(displayTags.map(\.id))

            return (nextState, .none)

        case .addNewTag:
            nextState.alert = .edit(.addition)
            return (nextState, .none)

        case let .saveNewTag(tagName):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.createTag(by: .init(name: tagName))
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToSaveTag(error)
                } catch {
                    return .failedToSaveTag(nil)
                }
            }
            return (nextState, [effect])

        case let .select(tagId):
            nextState.navigation = .tsundocList(tagId)
            return (nextState, .none)

        case let .tap(tagId, .copy):
            guard let tag = state.tags.first(where: { $0.id == tagId }) else {
                return (nextState, .none)
            }
            dependency.pasteboard.set(tag.name)
            return (nextState, .none)

        case let .tap(tagId, .rename):
            nextState.alert = .edit(.rename(tagId))
            return (nextState, .none)

        case let .tap(tagId, .delete):
            guard let tag = state.tags.first(where: { $0.id == tagId }) else {
                return (nextState, .none)
            }
            let title = L10n.tagListAlertDeleteTagMessage(tag.name)
            let action = L10n.tagListAlertDeleteTagAction
            return (nextState, [Effect(value: .present(.deleteConfirmation(tagId, title: title, action: action)))])

        case .failedToSaveTag:
            nextState.alert = .plain(.failedToAddTag)
            return (nextState, .none)

        case .failedToDeleteTag:
            nextState.alert = .plain(.failedToDeleteTag)
            return (nextState, .none)

        case .failedToUpdateTag:
            nextState.alert = .plain(.failedToUpdateTag)
            return (nextState, .none)

        case let .alert(.updatedTitle(title)):
            guard let tagId = state.renamingTagId else {
                nextState.alert = nil
                return (nextState, .none)
            }
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.updateTag(having: tagId, nameTo: title)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToUpdateTag(error)
                } catch {
                    return .failedToUpdateTag(nil)
                }
            }
            return (nextState, [effect])

        case let .alert(.confirmedToDelete(tagId)):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.deleteTag(having: tagId)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToDeleteTag(error)
                } catch {
                    return .failedToDeleteTag(nil)
                }
            }
            return (nextState, [effect])

        case .alert(.dismissed):
            nextState.alert = nil
            return (nextState, .none)

        case .navigation(.deactivated):
            nextState.navigation = nil
            return (nextState, .none)

        case .present:
            // NOP
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
            .map { Action.updateTags($0) as Action? }
        let tagsEffect = Effect(tagsStream, underlying: entities)

        nextState.tags = entities.values.value

        return (nextState, [tagsEffect])
    }
}
