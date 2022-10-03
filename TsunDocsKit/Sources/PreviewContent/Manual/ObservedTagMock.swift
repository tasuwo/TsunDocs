//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

#if DEBUG

import Combine
import Domain

public class ObservedTagMock: ObservedEntity {
    public init() { }
    public init(value: CurrentValueSubject<Entity, Error>) {
        self._value = value
    }

    public typealias Entity = Tag

    public private(set) var valueSetCallCount = 0
    private var _value: CurrentValueSubject<Entity, Error>! { didSet { valueSetCallCount += 1 } }
    public var value: CurrentValueSubject<Entity, Error> {
        get { return _value }
        set { _value = newValue }
    }
}

#endif
