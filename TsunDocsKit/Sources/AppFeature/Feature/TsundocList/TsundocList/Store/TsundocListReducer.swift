//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain
import Environment
import Foundation

public typealias TsundocListDependency = HasTsundocQueryService
    & HasTsundocCommandService
    & HasTagQueryService
    & HasPasteboard

public struct TsundocListReducer: Reducer {
    public typealias Dependency = TsundocListDependency
    public typealias State = TsundocListState
    public typealias Action = TsundocListAction

    // MARK: - Initializers

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case .onAppear:
            return Self.prepareQueryEffects(nextState, dependency)

        case let .updateTsundocs(tsundocs):
            nextState.tsundocs = tsundocs
            return (nextState, nil)

        case let .updateEmojiInfo(info, tsundocId):
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.updateTsundoc(having: tsundocId, emojiAlias: info.emoji.alias, emojiBackgroundColor: info.backgroundColor)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToUpdateTsundoc(error)
                } catch {
                    return .failedToUpdateTsundoc(nil)
                }
            }
            nextState.modal = nil
            return (nextState, [effect])

        case let .delete(tsundoc):
            let nextState = Self.delete(tsundoc, state, dependency)
            return (nextState, nil)

        case let .toggleUnread(tsundoc):
            let nextState = Self.toggleUnread(tsundoc, state, dependency)
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

        case .createTsundoc:
            nextState.alert = .textEdit(.createTsundoc)
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

        case let .tap(tsundocId, .addEmoji):
            nextState.modal = .emojiSelection(tsundocId)
            return (nextState, nil)

        case let .tap(tsundocId, .delete):
            nextState.alert = .confirmation(.delete(tsundocId))
            return (nextState, nil)

        case let .activateTsundocFilter(filter):
            nextState.tsundocFilter = filter
            nextState.isTsundocFilterActive = true
            return (nextState, nil)

        case .deactivateTsundocFilter:
            nextState.isTsundocFilterActive = false
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

        case let .alert(.createTsundoc(url)):
            nextState.alert = nil
            nextState.modal = .createTsundoc(url)
            return (nextState, nil)

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
        let tsundocsEffect = AnimatingEffect(tsundocsStream, underlying: entities, animateWith: .default)

        nextState.tsundocs = entities.values.value

        return (nextState, [tsundocsEffect])
    }
}

// MARK: - Deletion

extension TsundocListReducer {
    private static func delete(_ tsundoc: Tsundoc, _ state: State, _ dependency: Dependency) -> State {
        var nextState = state

        var failedToDelete = false
        dependency.tsundocCommandService.perform {
            do {
                try dependency.tsundocCommandService.begin()

                var failures: [CommandServiceError] = []
                if let failure = dependency.tsundocCommandService.deleteTsundoc(having: tsundoc.id).failureValue {
                    failures.append(failure)
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

        if let index = state.tsundocs.firstIndex(of: tsundoc) {
            nextState.tsundocs.remove(at: index)
        }

        return nextState
    }

    private static func toggleUnread(_ tsundoc: Tsundoc, _ state: State, _ dependency: Dependency) -> State {
        var nextState = state

        var failedToDelete = false
        dependency.tsundocCommandService.perform {
            do {
                try dependency.tsundocCommandService.begin()

                var failures: [CommandServiceError] = []
                if let failure = dependency.tsundocCommandService.updateTsundoc(having: tsundoc.id, isUnread: !tsundoc.isUnread).failureValue {
                    failures.append(failure)
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
            nextState.alert = .plain(.failedToUpdate)
            return nextState
        }

        return nextState
    }
}
