//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

/// @mockable
public protocol CloudKitAvailabilityObservable {
    var cloudKitAccountAvailability: AnyPublisher<Bool?, Never> { get }
    var isCloudKitAccountAvaialbe: Bool? { get }
}
