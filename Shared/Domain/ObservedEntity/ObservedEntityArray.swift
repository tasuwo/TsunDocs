//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine

protocol ObservedEntityArray {
    associatedtype Entity
    var values: CurrentValueSubject<[Entity], Error> { get }
}
