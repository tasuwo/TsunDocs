//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain
import Environment

public typealias TsundocInfoViewDependency = HasTagQueryService
    & HasTsundocCommandService
    & HasTsundocQueryService

public struct TsundocInfoViewReducer: Reducer {
    public typealias Dependency = TsundocInfoViewDependency
    public typealias State = TsundocInfoViewState
    public typealias Action = TsundocInfoViewAction

    // MARK: - Initializers

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
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

        case let .editEmojiInfo(emojiInfo):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: state.tsundoc.id, emojiAlias: emojiInfo?.emoji.alias, emojiBackgroundColor: emojiInfo?.backgroundColor)
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
        let tsundocEffect = AnimatingEffect(tsundocStream, underlying: tsundocEntity, animateWith: .default)

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
        let tagsEffect = AnimatingEffect(tagStream, underlying: tagEntities, animateWith: .default)

        nextState.tags = tagEntities.values.value

        return (nextState, [tsundocEffect, tagsEffect])
    }
}
