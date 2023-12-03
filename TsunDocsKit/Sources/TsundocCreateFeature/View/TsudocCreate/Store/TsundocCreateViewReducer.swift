//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain
import Environment
import Foundation

public typealias TsundocCreateViewDependency = HasSharedUserSettingStorage
    & HasTsundocCommandService
    & HasWebPageMetaResolver

public struct TsundocCreateViewReducer: Reducer {
    public typealias Dependency = TsundocCreateViewDependency
    public typealias State = TsundocCreateViewState
    public typealias Action = TsundocCreateViewAction

    // MARK: - Initializers

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case .onAppear:
            return Self.prepare(state: state, dependency: dependency)

        case let .onLoad(meta):
            nextState.sharedUrlTitle = meta?.title
            nextState.sharedUrlDescription = meta?.description
            nextState.sharedUrlImageUrl = meta?.imageUrl
            nextState.isPreparing = false
            return (nextState, .none)

        case .onTapSaveButton:
            guard let command = state.command() else {
                return (nextState, .none)
            }
            let effect = Effect<Action> {
                do {
                    try await dependency.tsundocCommandService.createTsundoc(by: command)
                    return .succeededToSave
                } catch {
                    return .failedToSave
                }
            }
            return (nextState, [effect])

        case .succeededToSave:
            nextState.isSucceeded = true
            return (nextState, .none)

        case .failedToSave:
            nextState.alert = .failedToSaveSharedUrl
            return (nextState, .none)

        case let .onSaveTitle(title):
            nextState.sharedUrlTitle = title
            return (nextState, .none)

        case let .onSelectedEmojiInfo(emojiInfo):
            nextState.selectedEmojiInfo = emojiInfo
            return (nextState, .none)

        case let .onSelectedTags(tags):
            nextState.selectedTags = tags
            return (nextState, .none)

        case let .onDeleteTag(tagId):
            nextState.selectedTags.removeAll(where: { $0.id == tagId })
            return (nextState, .none)

        case let .onToggleUnread(isUnread):
            nextState.isUnread = isUnread
            return (nextState, .none)

        case .errorConfirmed:
            nextState.isSucceeded = false
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

extension TsundocCreateViewReducer {
    private static func prepare(state: State, dependency: Dependency) -> (State, [Effect<Action>]) {
        var nextState = state

        let stream = Deferred {
            Future<Action?, Never> { promise in
                let meta = try? dependency.webPageMetaResolver.resolve(from: state.url)
                promise(.success(.onLoad(meta)))
            }
        }
        let effect = Effect(stream)

        nextState.isUnread = !dependency.sharedUserSettingStorage.markAsReadAtCreateValue

        return (nextState, [effect])
    }
}
