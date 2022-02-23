//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Foundation
import MobileShareExtensionUIKit
import Persistence
import UIKit

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

    private let _tagQueryService: Domain.TagQueryService
    private let _tsundocCommandService: Domain.TsundocCommandService
    private let _tagCommandService: Domain.TagCommandService

    // MARK: - Initializers

    init(appBundle: Bundle, context: NSExtensionContext) {
        self.context = context

        _sharedUrlLoader = SharedUrlLoader(context)
        _webPageMetaResolver = WebPageMetaResolver()

        container = PersistentContainer(appBundle: appBundle, author: .shareExtension)
        commandContext = container.newBackgroundContext(on: commandQueue)

        _tagQueryService = TagQueryService(container.viewContext)
        _tsundocCommandService = TsundocCommandService(commandContext)
        _tagCommandService = TagCommandService(commandContext)
    }
}

extension DependencyContainer: HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoadable { _sharedUrlLoader }
}

extension DependencyContainer: HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolvable { _webPageMetaResolver }
}

extension DependencyContainer: HasTagQueryService {
    var tagQueryService: Domain.TagQueryService { _tagQueryService }
}

extension DependencyContainer: HasTsundocCommandService {
    var tsundocCommandService: Domain.TsundocCommandService { _tsundocCommandService }
}

extension DependencyContainer: HasTagCommandService {
    var tagCommandService: Domain.TagCommandService { _tagCommandService }
}

extension DependencyContainer: HasCompletable {
    var completable: Completable { context }
}

extension DependencyContainer: HasPasteboard {
    var pasteboard: Pasteboard { UIPasteboard.general }
}

extension DependencyContainer: HasNop {}
