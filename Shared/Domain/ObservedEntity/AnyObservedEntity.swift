//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine

private class ObservedEntityBoxBase<Entity> {
    var value: CurrentValueSubject<Entity, Error> { fatalError("Abstract property called") }
}

private class ObservedEntityBox<ObservedEntity: TsunDocs.ObservedEntity>: ObservedEntityBoxBase<ObservedEntity.Entity> {
    private let base: ObservedEntity

    // MARK: - ObservedEntity

    override var value: CurrentValueSubject<ObservedEntity.Entity, Error> { base.value }

    // MARK: - Initializers

    init(_ base: ObservedEntity) {
        self.base = base
    }
}

class AnyObservedEntity<Entity> {
    // MARK: - Properties

    private let box: ObservedEntityBoxBase<Entity>

    // MARK: - Initializers

    init<ObservedEntity: TsunDocs.ObservedEntity>(_ base: ObservedEntity) where ObservedEntity.Entity == Entity {
        self.box = ObservedEntityBox(base)
    }
}

extension AnyObservedEntity: ObservedEntity {
    // MARK: - ObservedEntity

    var value: CurrentValueSubject<Entity, Error> { box.value }
}
