//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

public class Effect<Action: CompositeKit.Action> {
    // MARK: - Properties

    let id: UUID
    let upstream: AnyPublisher<ActionDispatcher<Action>?, Never>
    let actionAtCompleted: ActionDispatcher<Action>?
    let underlyingObject: Any?

    // MARK: - Initializers

    public init<P: Publisher>(_ publisher: P,
                              completeWith action: Action? = nil,
                              dispatchWith dispatcher: ((() -> Void) -> Void)? = nil) where P.Output == Action?, P.Failure == Never
    {
        self.id = UUID()
        self.upstream = publisher
            .map { .init(action: $0, with: dispatcher) }
            .eraseToAnyPublisher()
        self.underlyingObject = nil
        self.actionAtCompleted = .init(action: action)
    }

    public init<P: Publisher>(_ publisher: P,
                              underlying object: Any?,
                              completeWith action: Action? = nil,
                              dispatchWith dispatcher: ((() -> Void) -> Void)? = nil) where P.Output == Action?, P.Failure == Never
    {
        self.id = UUID()
        self.upstream = publisher
            .map { .init(action: $0, with: dispatcher) }
            .eraseToAnyPublisher()
        self.underlyingObject = object
        self.actionAtCompleted = .init(action: action)
    }

    public init<P: Publisher>(id: UUID,
                              publisher: P,
                              underlying object: Any?,
                              completeWith action: Action? = nil,
                              dispatchWith dispatcher: ((() -> Void) -> Void)? = nil) where P.Output == Action?, P.Failure == Never
    {
        self.id = id
        self.upstream = publisher
            .map { .init(action: $0, with: dispatcher) }
            .eraseToAnyPublisher()
        self.underlyingObject = object
        self.actionAtCompleted = .init(action: action)
    }

    public init(value action: Action, dispatchWith dispatcher: ((() -> Void) -> Void)? = nil) {
        self.id = UUID()
        self.upstream = Just(action as Action?)
            .map { .init(action: $0, with: dispatcher) }
            .eraseToAnyPublisher()
        self.underlyingObject = nil
        self.actionAtCompleted = nil
    }

    public init(_ block: @escaping () async -> Action?, dispatchWith dispatcher: ((() -> Void) -> Void)? = nil) {
        let stream: AnyPublisher<ActionDispatcher?, Never> = Deferred {
            Future { promise in
                Task {
                    await promise(.success(block()))
                }
            }
        }
        .map { .init(action: $0, with: dispatcher) }
        .eraseToAnyPublisher()
        self.id = UUID()
        self.upstream = stream
        self.underlyingObject = nil
        self.actionAtCompleted = nil
    }

    init<P: Publisher>(id: UUID, publisher: P, underlying object: Any?, completeWith action: ActionDispatcher<Action>? = nil) where P.Output == ActionDispatcher<Action>?, P.Failure == Never {
        self.id = id
        self.upstream = publisher
            .eraseToAnyPublisher()
        self.underlyingObject = object
        self.actionAtCompleted = action
    }
}

public extension Effect {
    func map<T: CompositeKit.Action>(_ transform: @escaping (Action?) -> T?) -> Effect<T> {
        .init(id: id,
              publisher: upstream.map({ $0?.map(transform) }).eraseToAnyPublisher(),
              underlying: underlyingObject,
              completeWith: actionAtCompleted?.map(transform))
    }
}
