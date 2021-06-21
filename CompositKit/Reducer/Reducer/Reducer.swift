//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol Reducer {
    associatedtype Action: CompositKit.Action
    associatedtype State: Equatable
    associatedtype Dependency

    func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?)
}

public extension Reducer {
    func eraseToAnyReducer() -> AnyReducer<Action, State, Dependency> {
        return .init(self)
    }
}
