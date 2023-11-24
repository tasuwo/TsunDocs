//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

/// @mockable
public protocol UserSettingStorage {
    var isiCloudSyncEnabled: AnyPublisher<Bool, Never> { get }
    var markAsReadAutomatically: AnyPublisher<Bool, Never> { get }
    var isiCloudSyncEnabledValue: Bool { get }
    var markAsReadAutomaticallyValue: Bool { get }
    func set(isiCloudSyncEnabled: Bool)
    func set(markAsReadAutomatically: Bool)
}
