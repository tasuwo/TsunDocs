//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Persistence

class AppDependencyContainer: ObservableObject {
    // MARK: - Properties

    static let shared = AppDependencyContainer()

    // MARK: CoreData

    private let container: PersistentContainer
    private let commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    // MARK: Query

    let tsundocQueryService: Domain.TsundocQueryService
    let tagQueryService: Domain.TagQueryService

    // MARK: Command

    let tsundocCommandService: Domain.TsundocCommandService
    let tagCommandService: Domain.TagCommandService

    // MARK: - Initializers

    private init() {
        container = PersistentContainer(author: .app)
        commandContext = container.newBackgroundContext(on: commandQueue)

        tsundocQueryService = TsundocQueryService(container.viewContext)
        tagQueryService = TagQueryService(container.viewContext)

        tsundocCommandService = TsundocCommandService(commandContext)
        tagCommandService = TagCommandService(commandContext)
    }
}
