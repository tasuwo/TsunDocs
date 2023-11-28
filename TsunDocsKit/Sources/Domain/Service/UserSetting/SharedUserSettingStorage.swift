//
//  Copyright ©︎ 2023 Tasuku Tozawa. All rights reserved.
//

import Combine

/// @mockable
public protocol SharedUserSettingStorage {
    var markAsReadAtCreate: AnyPublisher<Bool, Never> { get }
    var markAsReadAtCreateValue: Bool { get }
    func set(markAsReadAtCreate: Bool)
}
