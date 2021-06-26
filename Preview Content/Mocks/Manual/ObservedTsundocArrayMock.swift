//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Domain

class ObservedTsundocArrayMock: ObservedEntityArray {
    public init(values: CurrentValueSubject<[Tsundoc], Error>) {
        self._values = values
    }

    public typealias Entity = Tsundoc

    public private(set) var valuesSetCallCount = 0
    private var _values: CurrentValueSubject<[Tsundoc], Error>! { didSet { valuesSetCallCount += 1 } }
    public var values: CurrentValueSubject<[Tsundoc], Error> {
        get { return _values }
        set { _values = newValue }
    }
}
