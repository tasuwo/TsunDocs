//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Environment
import Foundation
import Persistence
import SaveUrlFeature
import UIKit

public class DependencyContainer: ObservableObject {
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

    public init(appBundle: Bundle, context: NSExtensionContext) {
        self.context = context

        _sharedUrlLoader = SharedUrlLoader(context)
        _webPageMetaResolver = WebPageMetaResolver()

        container = PersistentContainer(appBundle: appBundle,
                                        author: .shareExtension,
                                        isiCloudSyncSettingEnabled: false)
        commandContext = container.newBackgroundContext(on: commandQueue)

        _tagQueryService = TagQueryService(container.viewContext)
        _tsundocCommandService = TsundocCommandService(commandContext)
        _tagCommandService = TagCommandService(commandContext)
    }
}

extension DependencyContainer: HasSharedUrlLoader {
    public var sharedUrlLoader: SharedUrlLoadable { _sharedUrlLoader }
}

extension DependencyContainer: HasWebPageMetaResolver {
    public var webPageMetaResolver: WebPageMetaResolvable { _webPageMetaResolver }
}

extension DependencyContainer: HasTagQueryService {
    public var tagQueryService: Domain.TagQueryService { _tagQueryService }
}

extension DependencyContainer: HasTsundocCommandService {
    public var tsundocCommandService: Domain.TsundocCommandService { _tsundocCommandService }
}

extension DependencyContainer: HasTagCommandService {
    public var tagCommandService: Domain.TagCommandService { _tagCommandService }
}

extension DependencyContainer: HasCompletable {
    public var completable: Completable { context }
}

extension DependencyContainer: HasPasteboard {
    public var pasteboard: Pasteboard { UIPasteboard.general }
}

extension DependencyContainer: HasNop {}
