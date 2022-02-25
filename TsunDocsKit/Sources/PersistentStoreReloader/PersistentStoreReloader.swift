//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

public class PersistentStoreReloader {
    private let persistentStore: PersistentStore
    private let settingStorage: ICloudSyncSettingStorage
    private let cloudKitAvailabiltyObserver: CloudKitAvailabilityObservable

    private var subscriptions = Set<AnyCancellable>()

    public var accountChanged: PassthroughSubject<Void, Never> = .init()
    public var isiCloudSyncDisabledByUnavailableAccount: PassthroughSubject<Void, Never> = .init()

    // MARK: - Lifecycle

    public init(persistentStore: PersistentStore,
                settingStorage: ICloudSyncSettingStorage,
                cloudKitAvailabilityObserver: CloudKitAvailabilityObservable)
    {
        self.persistentStore = persistentStore
        self.settingStorage = settingStorage
        self.cloudKitAvailabiltyObserver = cloudKitAvailabilityObserver
    }

    // MARK: - Methods

    public func startObserve() {
        cloudKitAvailabiltyObserver.availability
            .compactMap { $0 }
            .catch { _ in Just(.unavailable) }
            .combineLatest(settingStorage.isiCloudSyncEnabled)
            .sink { [weak self] availability, isiCloudSyncEnabled in
                guard let self = self else { return }
                switch (isiCloudSyncEnabled, availability) {
                case (true, .available(.none)):
                    self.reloadPersistentStoreIfNeeded(isiCloudSyncEnabled: true)

                case (true, .available(.accountChanged)):
                    self.reloadPersistentStoreIfNeeded(isiCloudSyncEnabled: true)
                    // NOTE: アカウント変更の場合は、リロードの成否にかかわらず通知する
                    self.accountChanged.send(())

                case (true, .unavailable):
                    if self.reloadPersistentStoreIfNeeded(isiCloudSyncEnabled: false) {
                        self.isiCloudSyncDisabledByUnavailableAccount.send(())
                    }

                case (false, _):
                    self.reloadPersistentStoreIfNeeded(isiCloudSyncEnabled: false)
                }
            }
            .store(in: &subscriptions)
    }

    @discardableResult
    private func reloadPersistentStoreIfNeeded(isiCloudSyncEnabled: Bool) -> Bool {
        guard isiCloudSyncEnabled != persistentStore.isiCloudSyncEnabled else { return false }
        persistentStore.reload(isiCloudSyncEnabled: isiCloudSyncEnabled)
        return true
    }
}
