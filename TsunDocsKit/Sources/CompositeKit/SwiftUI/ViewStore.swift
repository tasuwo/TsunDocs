//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
public class ViewStore<State: Equatable, Action: CompositeKit.Action, Dependency>: ObservableObject {
    // MARK: - Properties

    private let store: AnyStoring<State, Action, Dependency>
    private var cancellable: AnyCancellable?

    public var state: State {
        willSet {
            objectWillChange.send()
        }
    }

    // MARK: - Initializers

    public init<Store: Storing>(store: Store)
        where Store.State == State,
        Store.Action == Action,
        Store.Dependency == Dependency
    {
        self.store = store.eraseToAnyStoring()
        self.state = store.stateValue
        self.cancellable = store.state
            .removeDuplicates()
            .sink { [weak self] in self?.state = $0 }
    }

    // MARK: - Methods

    public func execute(_ action: Action) {
        store.execute(action)
    }

    public func execute(_ action: Action, animation: Animation?) {
        withAnimation(animation) {
            store.execute(action)
        }
    }

    public func bind<T>(_ keyPath: KeyPath<State, T>,
                        action: @escaping (T) -> Action) -> Binding<T>
    {
        return Binding(get: {
            return self.store.stateValue[keyPath: keyPath]
        }, set: {
            self.store.execute(action($0))
        })
    }

    public func bind<T>(_ block: @escaping (State) -> T,
                        action: @escaping (T) -> Action) -> Binding<T>
    {
        return Binding(get: {
            return block(self.store.stateValue)
        }, set: {
            self.store.execute(action($0))
        })
    }
}

public extension ViewStore {
    func proxy<
        ChildState: Equatable,
        ChildAction: CompositeKit.Action,
        ChildDependency
    >(
        _ stateMapping: StateMapping<State, ChildState>,
        _ actionMapping: ActionMapping<Action, ChildAction>
    ) -> StoreProxy<
        ChildState,
        ChildAction,
        ChildDependency,
        State,
        Action,
        Dependency
    > {
        return .init(store: store,
                     stateMapping: stateMapping,
                     actionMapping: actionMapping)
    }
}

public extension ViewStore {
    func connection<
        Property: Equatable,
        Action: CompositeKit.Action
    >(
        at keyPath: KeyPath<State, Property>,
        _ mapping: @escaping (Property) -> Action?
    ) -> Connection<Action> {
        store.state
            .removeDuplicates(by: keyPath)
            .map(keyPath)
            .map { mapping($0) }
            .eraseToAnyPublisher()
    }
}

public extension Storing {
    func viewStore() -> ViewStore<State, Action, Dependency> {
        return ViewStore(store: self)
    }
}
