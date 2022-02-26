//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Persistence
import PersistentStoreReloader

public class AppDependencyContainer: ObservableObject {
    // MARK: CoreData

    private let container: PersistentContainer
    private let containerMonitor: PersistentContainerMonitor
    private let commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    let cloudKitAvailabilityObserver: CloudKitAvailabilityObserver

    // MARK: Query

    let tsundocQueryService: Domain.TsundocQueryService
    let tagQueryService: Domain.TagQueryService

    // MARK: Command

    let tsundocCommandService: Domain.TsundocCommandService
    let tagCommandService: Domain.TagCommandService

    // MARK: Storage

    let userSettingStorage: Domain.UserSettingStorage

    // MARK: - Initializers

    public init(appBundle: Bundle) {
        container = PersistentContainer(appBundle: appBundle, author: .app)
        containerMonitor = PersistentContainerMonitor()
        commandContext = container.newBackgroundContext(on: commandQueue)
        cloudKitAvailabilityObserver = CloudKitAvailabilityObserver(ckAccountStatusObserver: CKAccountStatusObserver())

        tsundocQueryService = TsundocQueryService(container.viewContext)
        tagQueryService = TagQueryService(container.viewContext)

        tsundocCommandService = TsundocCommandService(commandContext)
        tagCommandService = TagCommandService(commandContext)

        userSettingStorage = Persistence.UserSettingStorage(userDefaults: UserDefaults.standard)

        containerMonitor.startMonitoring()
    }
}
