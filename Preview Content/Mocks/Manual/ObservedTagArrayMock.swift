//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Domain

class ObservedTagArrayMock: ObservedEntityArray {
    init(values: CurrentValueSubject<[Tag], Error>) {
        self._values = values
    }

    typealias Entity = Tag

    private(set) var valuesSetCallCount = 0
    private var _values: CurrentValueSubject<[Tag], Error>! { didSet { valuesSetCallCount += 1 } }
    var values: CurrentValueSubject<[Tag], Error> {
        get { return _values }
        set { _values = newValue }
    }
}
