//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public extension ObservedEntityArray {
    func eraseToAnyObservedEntityArray() -> AnyObservedEntityArray<Entity> {
        return .init(self)
    }
}
