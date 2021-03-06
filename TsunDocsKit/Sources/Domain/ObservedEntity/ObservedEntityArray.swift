//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine

/// @mockable
public protocol ObservedEntityArray {
    associatedtype Entity
    var values: CurrentValueSubject<[Entity], Error> { get }
}
