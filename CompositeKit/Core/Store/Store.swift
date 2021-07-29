//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

@MainActor
public class Store<State: Equatable, Action: CompositeKit.Action, Dependency>: Storing {
    public var stateValue: State { _state.value }
    public var state: AnyPublisher<State, Never> { _state.eraseToAnyPublisher() }

    private let dependency: Dependency
    private let reducer: AnyReducer<Action, State, Dependency>
    private let _state: CurrentValueSubject<State, Never>

    private var isStateUpdating = false
    private let effectsLock = NSRecursiveLock()
    private var effects: [UUID: (Effect<Action>, Cancellable)] = [:]
    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init<R: Reducer>(initialState: State, dependency: Dependency, reducer: R) where R.Action == Action, R.State == State, R.Dependency == Dependency {
        self._state = .init(initialState)
        self.dependency = dependency
        self.reducer = reducer.eraseToAnyReducer()
    }

    // MARK: - Methods

    public func execute(_ action: Action) {
        // Reducer内の副作用で、状態の更新中にactionが発行される可能性がある
        // その場合には次回の実行に回す
        guard !isStateUpdating else {
            schedule(Effect(value: action))
            return
        }

        isStateUpdating = true

        let (nextState, effects) = reducer.execute(action: action, state: _state.value, dependency: dependency)

        _state.send(nextState)

        isStateUpdating = false

        if let effects = effects { effects.forEach { schedule($0) } }
    }

    private func schedule(_ effect: Effect<Action>) {
        effectsLock.lock()
        defer { effectsLock.unlock() }

        let id = effect.id

        if let (_, cancellable) = effects[id] {
            cancellable.cancel()
            effects.removeValue(forKey: id)
        }

        let cancellable = effect.upstream
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .sink { [weak self, weak effect] _ in
                guard let self = self else { return }

                self.effectsLock.lock()
                defer { self.effectsLock.unlock() }

                if let dispatcher = effect?.actionAtCompleted {
                    dispatcher.dispatchAndWait { self.execute($0) }
                }

                self.effects.removeValue(forKey: id)
            } receiveValue: { [weak self] dispatcher in
                dispatcher?.dispatchAndWait { self?.execute($0) }
            }

        effects[id] = (effect, cancellable)
    }
}
