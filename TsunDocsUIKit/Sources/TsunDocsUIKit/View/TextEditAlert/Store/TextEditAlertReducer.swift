//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit

protocol TextEditAlertDependency {
    var validator: ((String?) -> Bool)? { get }
    var saveAction: ((String) -> Void)? { get }
    var cancelAction: (() -> Void)? { get }
}

struct TextEditAlertReducer: Reducer {
    typealias Dependency = TextEditAlertDependency
    typealias State = TextEditAlertState
    typealias Action = TextEditAlertAction

    // MARK: - Methods

    func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        case .presented:
            nextState.shouldReturn = dependency.validator?(nextState.text) ?? true
            nextState.isInvalidated = false
            return (nextState, .none)

        case let .configUpdated(title: title, message: message, placeholder: placeholder):
            nextState.title = title
            nextState.message = message
            nextState.placeholder = placeholder
            return (nextState, .none)

        case let .textChanged(text: text):
            nextState.text = text
            nextState.shouldReturn = dependency.validator?(text) ?? true
            return (nextState, .none)

        case .saveActionTapped:
            guard !nextState.isInvalidated else { return (nextState, .none) }
            dependency.saveAction?(state.text)
            nextState.isInvalidated = true
            return (nextState, .none)

        case .cancelActionTapped, .dismissed:
            guard !nextState.isInvalidated else { return (nextState, .none) }
            dependency.cancelAction?()
            nextState.isInvalidated = true
            return (nextState, .none)
        }
    }
}
