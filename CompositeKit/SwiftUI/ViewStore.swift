//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import SwiftUI

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
        self.cancellable = store.state.sink { [weak self] in self?.state = $0 }
    }

    // MARK: - Methods

    public func execute(_ action: Action) {
        store.execute(action)
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
}
