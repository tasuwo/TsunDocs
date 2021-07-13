//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias SharedUrlEditViewDependency = HasSharedUrlLoader
    & HasWebPageMetaResolver
    & HasTsundocCommandService
    & HasCompletable

public struct SharedUrlEditViewReducer: Reducer {
    public typealias Dependency = SharedUrlEditViewDependency
    public typealias State = SharedUrlEditViewState
    public typealias Action = SharedUrlEditViewAction

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

            var isFailed = false
            dependency.tsundocCommandService.perform {
                do {
                    try dependency.tsundocCommandService.begin()

                    if dependency.tsundocCommandService.createTsundoc(by: command).failureValue != nil {
                        isFailed = true
                        try dependency.tsundocCommandService.cancel()
                        return
                    }

                    try dependency.tsundocCommandService.commit()
                } catch {
                    isFailed = true
                }
            }

            if isFailed {
                nextState.alert = .failedToSaveSharedUrl
                return (nextState, .none)
            }

            dependency.completable.complete()

            return (nextState, .none)

        case .onTapEditTitleButton:
            nextState.isTitleEditAlertPresenting = true
            return (nextState, .none)

        case .onTapEditTagButton:
            nextState.isTagEditSheetPresenting = true
            return (nextState, .none)

        case let .onSaveTitle(title):
            nextState.sharedUrlTitle = title
            return (nextState, .none)

        case .onFailedToLoadUrl:
            nextState.alert = .failedToLoadUrl
            return (nextState, .none)

        case let .onSelectedEmoji(emoji):
            nextState.selectedEmoji = emoji
            return (nextState, .none)

        case let .onSelectedTags(tags):
            nextState.selectedTags = tags
            nextState.isTagEditSheetPresenting = false
            return (nextState, .none)

        case let .onDeleteTag(tagId):
            nextState.selectedTags.removeAll(where: { $0.id == tagId })
            return (nextState, .none)

        case .errorConfirmed:
            dependency.completable.cancel(with: NSError()) // TODO:
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            nextState.isTitleEditAlertPresenting = false
            nextState.isTagEditSheetPresenting = false
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
