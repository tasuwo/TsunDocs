//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

class WeakContainerArray<T> {
    private var containers: [WeakContainer<T>]

    // MARK: - Initializers

    init() {
        containers = []
    }

    init(_ containers: [WeakContainer<T>]) {
        self.containers = containers
    }

    // MARK: - Methods

    subscript(_ index: Int) -> WeakContainer<T> {
        get {
            clean()
            return containers[index]
        }
        set {
            clean()
            containers[index] = newValue
        }
    }

    func append(_ value: T) {
        clean()
        containers.append(WeakContainer(value))
    }

    func remove(_ value: T) {
        clean()
        containers.removeAll(where: { $0.value as AnyObject === value as AnyObject })
    }

    func forEach(_ body: (T) -> Void) {
        clean()
        containers
            .compactMap { $0.value }
            .forEach(body)
    }

    private func clean() {
        containers = containers.filter { container -> Bool in
            return container.value != nil
        }
    }
}
