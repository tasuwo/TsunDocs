//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData
import CoreDataCloudKitSupport
import Domain
import Persistence

public class AppDependencyContainer: ObservableObject {
    // MARK: CoreData

    private let container: Persistence.PersistentContainer
    private let containerMonitor: PersistentContainerMonitor
    private var commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    let cloudKitAvailabilityObserver: CloudKitAvailabilityObserver
    private let persistentContainerReloader: PersistentContainerReloader

    // MARK: Query

    let tsundocQueryService: Persistence.TsundocQueryService
    let tagQueryService: Persistence.TagQueryService

    // MARK: Command

    let tsundocCommandService: Persistence.TsundocCommandService
    let tagCommandService: Persistence.TagCommandService

    // MARK: Storage

    let userSettingStorage: Domain.UserSettingStorage

    // MARK: Subscription

    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init(appBundle: Bundle) {
        let userSettingStorage = Persistence.UserSettingStorage(userDefaults: .standard)
        self.userSettingStorage = userSettingStorage

        container = PersistentContainer(appBundle: appBundle,
                                        author: .app,
                                        isiCloudSyncSettingEnabled: userSettingStorage.isiCloudSyncEnabledValue)
        containerMonitor = PersistentContainerMonitor()
        commandContext = container.newBackgroundContext(on: commandQueue)
        cloudKitAvailabilityObserver = CloudKitAvailabilityObserver(ckAccountStatusObserver: CKAccountStatusObserver())
        persistentContainerReloader = PersistentContainerReloader(persistentContainer: container,
                                                                  settingStorage: userSettingStorage,
                                                                  cloudKitAvailabilityObserver: cloudKitAvailabilityObserver,
                                                                  ckAccountIdStorage: CloudKitContextStorage(userDefaults: .standard))

        tsundocQueryService = TsundocQueryService(container.viewContext)
        tagQueryService = TagQueryService(container.viewContext)

        tsundocCommandService = TsundocCommandService(commandContext)
        tagCommandService = TagCommandService(commandContext)

        containerMonitor.startMonitoring()
        persistentContainerReloader.startObserve()

        bind()
    }
}

extension AppDependencyContainer {
    func bind() {
        container.reloaded
            .sink { [weak self] in
                guard let self = self else { return }

                let newCommandContext = self.container.newBackgroundContext(on: self.commandQueue)
                self.commandContext = newCommandContext

                self.tsundocQueryService.context = self.container.viewContext
                self.tagQueryService.context = self.container.viewContext

                self.commandQueue.sync {
                    self.tsundocCommandService.context = newCommandContext
                    self.tagCommandService.context = newCommandContext
                }
            }
            .store(in: &subscriptions)
    }
}

extension Persistence.UserSettingStorage: ICloudSyncSettingStorage {}

extension Persistence.PersistentContainer: CoreDataCloudKitSupport.PersistentContainer {}
