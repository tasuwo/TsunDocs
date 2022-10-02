//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper
import Domain
import Foundation

public class CloudKitContextStorage {
    // MARK: - Properties

    private let userDefaults: UserDefaults

    // MARK: - Initializers

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

extension UserDefaults {
    @objc dynamic var lastLoggedInCKAccountId: String? {
        return string(forKey: StorageKey.lastLoggedInCKAccountId.rawValue)
    }
}

extension CloudKitContextStorage: CKAccountIdStorage {
    // MARK: - CKAccountIdStorage

    public var lastLoggedInCKAccountId: String? {
        return userDefaults.lastLoggedInCKAccountId
    }

    public func set(lastLoggedInCKAccountId: String?) {
        userDefaults.set(lastLoggedInCKAccountId, forKey: StorageKey.lastLoggedInCKAccountId.rawValue)
    }
}
