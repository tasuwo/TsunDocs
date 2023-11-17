//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData
import Domain
import MobileSettingFeature
import Persistence
import PersistentStack

public class AppDependencyContainer {
    // MARK: CoreData

    private let persistentStack: PersistentStack
    private let persistentStackMonitor: PersistentStackMonitor
    private let persistentStackLoader: PersistentStackLoader
    private var persistentStackLoading: Task<Void, Never>?
    private var persistentStackReloading: AnyCancellable?

    private var commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable { persistentStackLoader }

    // MARK: Query

    let tsundocQueryService: Persistence.TsundocQueryService
    let tagQueryService: Persistence.TagQueryService

    // MARK: Command

    let tsundocCommandService: Persistence.TsundocCommandService
    let tagCommandService: Persistence.TagCommandService

    // MARK: Storage

    let userSettingStorage: Domain.UserSettingStorage

    // MARK: Others

    let webPageMetaResolver: WebPageMetaResolver

    // MARK: Subscription

    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init(appBundle: Bundle) {
        let userSettingStorage = Persistence.UserSettingStorage(userDefaults: .standard)
        self.userSettingStorage = userSettingStorage

        var persistentStackConf = PersistentStack.Configuration(author: "app",
                                                                persistentContainerName: "Model",
                                                                managedObjectModelUrl: .managedObjectModelUrl)
        persistentStackConf.persistentContainerUrl = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.\(appBundle.bundleIdentifier!)")!
            .appendingPathComponent("tsundocs.sqlite")
        persistentStackConf.persistentHistoryTokenSaveDirectory = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("TsunDocs", isDirectory: true)
        persistentStackConf.persistentHistoryTokenFileName = "app-token.data"
        persistentStack = PersistentStack(configuration: persistentStackConf,
                                          isCloudKitEnabled: userSettingStorage.isiCloudSyncEnabledValue)
        persistentStackLoader = PersistentStackLoader(persistentStack: persistentStack,
                                                      availabilityProvider: AppICloudSyncAvailabilityProvider(userSettingsStorage: userSettingStorage))
        persistentStackMonitor = PersistentStackMonitor()

        commandContext = persistentStack.newBackgroundContext(on: commandQueue)

        tsundocQueryService = TsundocQueryService(persistentStack.viewContext)
        tagQueryService = TagQueryService(persistentStack.viewContext)

        tsundocCommandService = TsundocCommandService(commandContext)
        tagCommandService = TagCommandService(commandContext)

        webPageMetaResolver = WebPageMetaResolver()

        persistentStackReloading = persistentStack
            .reloaded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }

                let newCommandContext = self.persistentStack.newBackgroundContext(on: self.commandQueue)
                self.commandContext = newCommandContext

                self.tsundocQueryService.context = self.persistentStack.viewContext
                self.tagQueryService.context = self.persistentStack.viewContext

                self.commandQueue.sync {
                    self.tsundocCommandService.context = newCommandContext
                    self.tagCommandService.context = newCommandContext
                }
            }

        persistentStackMonitor.startMonitoring()
        persistentStackLoading = persistentStackLoader.run()
    }
}

extension Persistence.UserSettingStorage: CloudKitSyncAvailabilityProviding {
    public var isCloudKitSyncAvailable: AsyncStream<Bool> {
        AsyncStream { [isiCloudSyncEnabled] continuation in
            let cancellable = isiCloudSyncEnabled
                .sink { continuation.yield($0) }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}

extension PersistentStackLoader: CloudKitAvailabilityObservable {
    public var cloudKitAccountAvailability: AnyPublisher<Bool?, Never> {
        return self.$isCKAccountAvailable.eraseToAnyPublisher()
    }

    public var isCloudKitAccountAvaialbe: Bool? {
        isCKAccountAvailable
    }
}
