//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper
import Domain
import Foundation

class CloudKitContextStorage {
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

    var lastLoggedInCKAccountId: String? {
        return userDefaults.lastLoggedInCKAccountId
    }

    func set(lastLoggedInCKAccountId: String?) {
        userDefaults.set(lastLoggedInCKAccountId, forKey: StorageKey.lastLoggedInCKAccountId.rawValue)
    }
}
