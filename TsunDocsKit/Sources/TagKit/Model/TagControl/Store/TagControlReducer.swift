//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagControlDependency = HasTagCommandService
    & HasTagQueryService

public struct TagControlReducer: Reducer {
    public typealias Dependency = TagControlDependency
    public typealias State = TagControlState
    public typealias Action = TagControlAction

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case .onAppear:
            return Self.prepareQueryEffects(nextState, dependency)

        case let .updatedTags(tags):
            nextState.tags = tags
            return (nextState, .none)

        case let .createNewTag(tagName):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.createTag(by: .init(name: tagName))
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToCreateTag(error)
                } catch {
                    return .failedToCreateTag(nil)
                }
            }
            return (nextState, [effect])

        case .failedToCreateTag:
            nextState.alert = .failedToCreateTag
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

// MARK: - Preparation

extension TagControlReducer {
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
            .map { Action.updatedTags($0) as Action? }
        let tagsEffect = Effect(tagsStream, underlying: entities)

        nextState.tags = entities.values.value

        return (nextState, [tagsEffect])
    }
}
