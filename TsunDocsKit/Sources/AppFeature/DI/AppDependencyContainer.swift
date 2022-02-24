//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Persistence

public class AppDependencyContainer: ObservableObject {
    // MARK: CoreData

    private let container: PersistentContainer
    private let containerMonitor: PersistentContainerMonitor
    private let commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    // MARK: Query

    let tsundocQueryService: Domain.TsundocQueryService
    let tagQueryService: Domain.TagQueryService

    // MARK: Command

    let tsundocCommandService: Domain.TsundocCommandService
    let tagCommandService: Domain.TagCommandService

    // MARK: - Initializers

    public init(appBundle: Bundle) {
        container = PersistentContainer(appBundle: appBundle, author: .app)
        containerMonitor = PersistentContainerMonitor()
        commandContext = container.newBackgroundContext(on: commandQueue)

        tsundocQueryService = TsundocQueryService(container.viewContext)
        tagQueryService = TagQueryService(container.viewContext)

        tsundocCommandService = TsundocCommandService(commandContext)
        tagCommandService = TagCommandService(commandContext)

        containerMonitor.startMonitoring()
    }
}
