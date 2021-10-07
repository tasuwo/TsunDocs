//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine

private class ObservedEntityArrayBoxBase<Entity> {
    var values: CurrentValueSubject<[Entity], Error> { fatalError("Abstract property called") }
}

private class ObservedEntityArrayBox<ObservedEntityArray: Domain.ObservedEntityArray>: ObservedEntityArrayBoxBase<ObservedEntityArray.Entity> {
    private let base: ObservedEntityArray

    // MARK: - ObservedEntityArray

    override var values: CurrentValueSubject<[ObservedEntityArray.Entity], Error> { base.values }

    // MARK: - Initializers

    init(_ base: ObservedEntityArray) {
        self.base = base
    }
}

public class AnyObservedEntityArray<Entity> {
    // MARK: - Properties

    private let box: ObservedEntityArrayBoxBase<Entity>

    // MARK: - Initializers

    public init<ObservedEntityArray: Domain.ObservedEntityArray>(_ base: ObservedEntityArray) where ObservedEntityArray.Entity == Entity {
        self.box = ObservedEntityArrayBox(base)
    }
}

extension AnyObservedEntityArray: ObservedEntityArray {
    // MARK: - ObservedEntityArray

    public var values: CurrentValueSubject<[Entity], Error> { box.values }
}
