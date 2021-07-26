//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

typealias TsundocInfoViewDependency = HasTsundocCommandService
    & HasTsundocQueryService
    & HasTagQueryService

struct TsundocInfoViewReducer: Reducer {
    typealias Dependency = TsundocInfoViewDependency
    typealias State = TsundocInfoViewState
    typealias Action = TsundocInfoViewAction

    // MARK: - Reducer

    func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case .onAppear:
            return Self.prepareQueryEffects(state, dependency)

        case let .updateTsundoc(tsundoc):
            nextState.tsundoc = tsundoc

        case let .updateTag(tags):
            nextState.tags = tags

        case let .editTitle(title):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: state.tsundoc.id, title: title)
                    return .none
                } catch {
                    return .failedToUpdate
                }
            }
            return (nextState, [effect])

        case let .editEmoji(emoji):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: state.tsundoc.id, emojiAlias: emoji?.alias)
                    return .none
                } catch {
                    return .failedToUpdate
                }
            }
            return (nextState, [effect])

        case let .editTags(tags):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: state.tsundoc.id, byReplacingTagsHaving: Set(tags.map(\.id)))
                    return .none
                } catch {
                    return .failedToUpdate
                }
            }
            return (nextState, [effect])

        case let .deleteTag(tagId):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: state.tsundoc.id, byRemovingTagHaving: tagId)
                    return .none
                } catch {
                    return .failedToUpdate
                }
            }
            return (nextState, [effect])

        case .failedToLoad:
            break

        case .failedToUpdate:
            break
        }

        return (nextState, .none)
    }
}

// MARK: - Preparation

extension TsundocInfoViewReducer {
    private static func prepareQueryEffects(_ state: State, _ dependency: Dependency) -> (State, [Effect<Action>]) {
        var nextState = state

        // Tsundoc

        let tsundocEntity: AnyObservedEntity<Tsundoc>
        switch dependency.tsundocQueryService.queryTsundoc(having: state.tsundoc.id) {
        case let .success(result):
            tsundocEntity = result

        case .failure:
            fatalError("Failed to load entities.")
        }

        let tsundocStream = tsundocEntity.value
            .map { Action.updateTsundoc($0) as Action? }
            .catch { _ in Just(Action.failedToLoad) }
        let tsundocEffect = Effect(tsundocStream, underlying: tsundocEntity)

        nextState.tsundoc = tsundocEntity.value.value

        // Tag

        let tagEntities: AnyObservedEntityArray<Tag>
        switch dependency.tagQueryService.queryTags(taggedToTsundocHaving: state.tsundoc.id) {
        case let .success(result):
            tagEntities = result

        case .failure:
            fatalError("Failed to load entities.")
        }

        let tagStream = tagEntities.values
            .map { Action.updateTag($0) as Action? }
            .catch { _ in Just(Action.failedToLoad) }
        let tagsEffect = Effect(tagStream, underlying: tagEntities)

        nextState.tags = tagEntities.values.value

        return (nextState, [tsundocEffect, tagsEffect])
    }
}
