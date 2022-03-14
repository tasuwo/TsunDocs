//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import Domain
import Foundation

public class UserSettingStorage {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [
            StorageKey.isiCloudSyncEnabled.rawValue: true
        ])
    }
}

extension UserDefaults {
    @objc dynamic var isiCloudSyncEnabled: Bool {
        return bool(forKey: StorageKey.isiCloudSyncEnabled.rawValue)
    }
}

extension UserSettingStorage: Domain.UserSettingStorage {
    // MARK: - Domain.UserSettingStorage

    public var isiCloudSyncEnabled: AnyPublisher<Bool, Never> {
        return userDefaults
            .publisher(for: \.isiCloudSyncEnabled)
            .eraseToAnyPublisher()
    }

    public var isiCloudSyncEnabledValue: Bool {
        return userDefaults.isiCloudSyncEnabled
    }

    public func set(isiCloudSyncEnabled: Bool) {
        userDefaults.set(isiCloudSyncEnabled, forKey: StorageKey.isiCloudSyncEnabled.rawValue)
    }
}
