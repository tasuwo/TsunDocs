//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Persistence

class DependencyContainer {
    // MARK: - Properties

    // MARK: CoreData

    private let coreDataStack: CoreDataStack
    private let commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    // MARK: Query

    private let _tsundocQueryService: Domain.TsundocQueryService
    private let _tagQueryService: Domain.TagQueryService

    // MARK: Command

    private let _tsundocCommandService: Domain.TsundocCommandService
    private let _tagCommandService: Domain.TagCommandService

    // MARK: - Initializers

    init() {
        coreDataStack = CoreDataStack()
        commandContext = coreDataStack.newBackgroundContext(on: commandQueue)

        _tsundocQueryService = TsundocQueryService(coreDataStack.viewContext)
        _tagQueryService = TagQueryService(coreDataStack.viewContext)

        _tsundocCommandService = TsundocCommandService(commandContext)
        _tagCommandService = TagCommandService(commandContext)
    }
}