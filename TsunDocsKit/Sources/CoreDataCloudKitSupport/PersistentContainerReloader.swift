//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

public class PersistentContainerReloader {
    // MARK: - Properties

    private let persistentContainer: PersistentContainer
    private let settingStorage: ICloudSyncSettingStorage
    private let cloudKitAvailabiltyObserver: CloudKitAvailabilityObservable
    private let ckAccountIdStorage: CKAccountIdStorage

    private var subscriptions = Set<AnyCancellable>()

    public let accountChanged: PassthroughSubject<Void, Never> = .init()
    public let isiCloudSyncDisabledByUnavailableAccount: PassthroughSubject<Void, Never> = .init()

    // MARK: - Initializers

    public init(persistentContainer: PersistentContainer,
                settingStorage: ICloudSyncSettingStorage,
                cloudKitAvailabilityObserver: CloudKitAvailabilityObservable,
                ckAccountIdStorage: CKAccountIdStorage)
    {
        self.persistentContainer = persistentContainer
        self.settingStorage = settingStorage
        self.cloudKitAvailabiltyObserver = cloudKitAvailabilityObserver
        self.ckAccountIdStorage = ckAccountIdStorage
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
                case let (true, .available(accountId: accountId)):
                    self.reloadPersistentStoreIfNeeded(isiCloudSyncEnabled: true)

                    let lastId = self.ckAccountIdStorage.lastLoggedInCKAccountId
                    self.ckAccountIdStorage.set(lastLoggedInCKAccountId: accountId)
                    if lastId != nil, lastId != accountId {
                        // NOTE: アカウント変更の場合は、リロードの成否にかかわらず通知する
                        self.accountChanged.send(())
                    }

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
        guard isiCloudSyncEnabled != persistentContainer.isiCloudSyncEnabled else { return false }
        persistentContainer.reload(isiCloudSyncSettingEnabled: isiCloudSyncEnabled)
        return true
    }
}
