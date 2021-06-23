//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public extension ObservedEntity {
    func eraseToAnyObservedEntity() -> AnyObservedEntity<Entity> {
        return .init(self)
    }
}
