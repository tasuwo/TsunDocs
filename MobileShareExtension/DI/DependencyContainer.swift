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

    // MARK: Shared Url

    private let _sharedUrlLoader: SharedUrlLoader
    private let _sharedUrlMetaResolver: SharedUrlMetaResolver

    // MARK: CoreData

    private let container: PersistentContainer
    private let commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    // MARK: Command

    private let _tsundocCommandService: Domain.TsundocCommandService

    // MARK: - Initializers

    init(_ context: NSExtensionContext) {
        self.context = context

        _sharedUrlLoader = SharedUrlLoader(context)
        _sharedUrlMetaResolver = SharedUrlMetaResolver()

        container = PersistentContainer(author: .shareExtension)
        commandContext = container.newBackgroundContext(on: commandQueue)

        _tsundocCommandService = TsundocCommandService(commandContext)
    }
}

extension DependencyContainer: HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoader { _sharedUrlLoader }
}

extension DependencyContainer: HasSharedUrlMetaResolver {
    var sharedUrlMetaResolver: SharedUrlMetaResolver { _sharedUrlMetaResolver }
}

extension DependencyContainer: HasTsundocCommandService {
    var tsundocCommandService: Domain.TsundocCommandService { _tsundocCommandService }
}