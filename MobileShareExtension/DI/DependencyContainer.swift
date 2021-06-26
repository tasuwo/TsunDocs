//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Foundation
import Persistence

class DependencyContainer: ObservableObject {
    // MARK: - Properties

    let context: NSExtensionContext

    // MARK: CoreData

    private let container: PersistentContainer
    private let commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    // MARK: Command

    let tsundocCommandService: Domain.TsundocCommandService

    // MARK: - Initializers

    init(_ context: NSExtensionContext) {
        self.context = context

        container = PersistentContainer(author: .shareExtension)
        commandContext = container.newBackgroundContext(on: commandQueue)

        tsundocCommandService = TsundocCommandService(commandContext)
    }
}
