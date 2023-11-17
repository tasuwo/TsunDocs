//
//  Copyright ©︎ 2023 Tasuku Tozawa. All rights reserved.
//

import AsyncAlgorithms
import Persistence
import PersistentStack

final class AppICloudSyncAvailabilityProvider {
    private let userSettingsStorage: UserSettingStorage

    init(userSettingsStorage: UserSettingStorage) {
        self.userSettingsStorage = userSettingsStorage
    }
}

extension AppICloudSyncAvailabilityProvider: CloudKitSyncAvailabilityProviding {
    var isCloudKitSyncAvailable: AsyncStream<Bool> {
        AsyncStream { continuation in
            let cancellable = userSettingsStorage.isiCloudSyncEnabled
                .sink { continuation.yield($0) }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }
}
