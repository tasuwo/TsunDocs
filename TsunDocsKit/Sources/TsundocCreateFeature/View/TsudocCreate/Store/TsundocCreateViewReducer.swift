//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain
import Environment
import Foundation

public typealias TsundocCreateViewDependency = HasSharedUrlLoader
    & HasWebPageMetaResolver
    & HasTsundocCommandService

public struct TsundocCreateViewReducer: Reducer {
    public typealias Dependency = TsundocCreateViewDependency
    public typealias State = TsudocCreateViewState
    public typealias Action = TsundocCreateViewAction

    // MARK: - Initializers

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case .onAppear:
            return Self.loadUrl(state: state, dependency: dependency)

        case let .onLoad(url, meta):
            nextState.sharedUrl = url
            nextState.sharedUrlTitle = meta?.title
            nextState.sharedUrlDescription = meta?.description
            nextState.sharedUrlImageUrl = meta?.imageUrl
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
            nextState.saveResult = .succeeded
            return (nextState, .none)

        case .failedToSave:
            nextState.alert = .failedToSaveSharedUrl
            return (nextState, .none)

        case let .onSaveTitle(title):
            nextState.sharedUrlTitle = title
            return (nextState, .none)

        case .onFailedToLoadUrl:
            nextState.alert = .failedToLoadUrl
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
            nextState.saveResult = .failed
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

extension TsundocCreateViewReducer {
    private static func loadUrl(state: State, dependency: Dependency) -> (State, [Effect<Action>]) {
        let stream = Deferred {
            Future<Action?, Never> { promise in
                DispatchQueue.global().async {
                    dependency.sharedUrlLoader.load { url in
                        guard let url = url else {
                            promise(.success(.onFailedToLoadUrl))
                            return
                        }

                        let meta = try? dependency.webPageMetaResolver.resolve(from: url)
                        promise(.success(.onLoad(url, meta)))
                    }
                }
            }
        }
        let effect = Effect(stream)

        return (state, [effect])
    }
}
