//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain
import Foundation

public typealias SharedUrlEditViewDependency = HasSharedUrlLoader
    & HasWebPageMetaResolver
    & HasTsundocCommandService
    & HasCompletable

public struct SharedUrlEditViewReducer: Reducer {
    public typealias Dependency = SharedUrlEditViewDependency
    public typealias State = SharedUrlEditViewState
    public typealias Action = SharedUrlEditViewAction

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
            dependency.completable.complete()
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

        case .errorConfirmed:
            dependency.completable.cancel(with: NSError()) // TODO:
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

extension SharedUrlEditViewReducer {
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
