//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public class WeakContainerArray<T> {
    private var containers: [WeakContainer<T>]

    // MARK: - Initializers

    public init() {
        containers = []
    }

    public init(_ values: [T]) {
        self.containers = values.map { WeakContainer($0) }
    }

    // MARK: - Methods

    public subscript(_ index: Int) -> T {
        get {
            clean()
            // swiftlint:disable:next force_unwrapping
            return containers[index].value!
        }
        set {
            clean()
            containers[index] = WeakContainer(newValue)
        }
    }

    public func append(_ value: T) {
        clean()
        containers.append(WeakContainer(value))
    }

    public func remove(_ value: T) {
        clean()
        containers.removeAll(where: { $0.value as AnyObject === value as AnyObject })
    }

    public func forEach(_ body: (T) -> Void) {
        clean()
        containers
            .compactMap(\.value)
            .forEach(body)
    }

    private func clean() {
        containers = containers.filter { container -> Bool in
            return container.value != nil
        }
    }
}
