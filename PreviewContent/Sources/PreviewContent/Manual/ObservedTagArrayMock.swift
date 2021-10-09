//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Domain

public class ObservedTagArrayMock: ObservedEntityArray {
    public init(values: CurrentValueSubject<[Tag], Error>) {
        self._values = values
    }

    public typealias Entity = Tag

    public private(set) var valuesSetCallCount = 0
    private var _values: CurrentValueSubject<[Tag], Error>! { didSet { valuesSetCallCount += 1 } }
    public var values: CurrentValueSubject<[Tag], Error> {
        get { return _values }
        set { _values = newValue }
    }
}
