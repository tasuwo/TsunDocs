//
//  Copyright ©︎ 2023 Tasuku Tozawa. All rights reserved.
//

import Combine
import Domain
import Foundation

public class SharedUserSettingStorage {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [
            StorageKey.markAsReadAtCreate.rawValue: false
        ])
    }
}

extension UserDefaults {
    @objc dynamic var markAsReadAtCreate: Bool {
        return bool(forKey: StorageKey.markAsReadAtCreate.rawValue)
    }
}

extension SharedUserSettingStorage: Domain.SharedUserSettingStorage {
    // MARK: - Domain.UserSettingStorage

    public var markAsReadAtCreate: AnyPublisher<Bool, Never> {
        return userDefaults
            .publisher(for: \.markAsReadAtCreate)
            .eraseToAnyPublisher()
    }

    public var markAsReadAtCreateValue: Bool {
        return userDefaults.markAsReadAtCreate
    }

    public func set(markAsReadAtCreate: Bool) {
        userDefaults.set(markAsReadAtCreate, forKey: StorageKey.markAsReadAtCreate.rawValue)
    }
}
