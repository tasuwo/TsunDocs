//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine

/// @mockable
public protocol ObservedEntity {
    associatedtype Entity
    var value: CurrentValueSubject<Entity, Error> { get }
}
