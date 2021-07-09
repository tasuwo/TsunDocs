//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Foundation
import MobileShareExtensionUIKit
import Persistence

class DependencyContainer: ObservableObject {
    // MARK: - Properties

    let context: NSExtensionContext

    // MARK: Shared Url

    private let _sharedUrlLoader: SharedUrlLoader
    private let _webPageMetaResolver: WebPageMetaResolver

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
        _webPageMetaResolver = WebPageMetaResolver()

        container = PersistentContainer(author: .shareExtension)
        commandContext = container.newBackgroundContext(on: commandQueue)

        _tsundocCommandService = TsundocCommandService(commandContext)
    }
}

extension DependencyContainer: HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoadable { _sharedUrlLoader }
}

extension DependencyContainer: HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolvable { _webPageMetaResolver }
}

extension DependencyContainer: HasTsundocCommandService {
    var tsundocCommandService: Domain.TsundocCommandService { _tsundocCommandService }
}

extension DependencyContainer: HasCompletable {
    var completable: Completable { context }
}

extension DependencyContainer: HasNop {}

