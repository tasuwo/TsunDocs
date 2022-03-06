//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

/// @mockable
public protocol UserSettingStorage {
    var isiCloudSyncEnabled: AnyPublisher<Bool, Never> { get }
    var isiCloudSyncEnabledValue: Bool { get }
    func set(isiCloudSyncEnabled: Bool)
}
