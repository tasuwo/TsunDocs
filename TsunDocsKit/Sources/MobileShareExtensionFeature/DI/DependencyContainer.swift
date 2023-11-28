//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain
import Environment
import Foundation
import Persistence
import PersistentStack
import TsundocCreateFeature
import UIKit

public class DependencyContainer: ObservableObject {
    // MARK: - Properties

    let context: NSExtensionContext

    // MARK: Shared Url

    private let _sharedUrlLoader: SharedUrlLoader
    private let _webPageMetaResolver: WebPageMetaResolver

    // MARK: CoreData

    private let persistentStack: PersistentStack
    private var commandContext: NSManagedObjectContext
    private let commandQueue = DispatchQueue(label: "net.tasuwo.tsundocs.DependencyContainer.commandQueue")

    // MARK: Command

    private let _tagQueryService: Domain.TagQueryService
    private let _tsundocCommandService: Domain.TsundocCommandService
    private let _tagCommandService: Domain.TagCommandService

    // MARK: Storage

    let _sharedUserSettingStorage: Domain.SharedUserSettingStorage

    // MARK: - Initializers

    public init(appBundle: Bundle, context: NSExtensionContext) {
        self.context = context

        _sharedUrlLoader = SharedUrlLoader(context)
        _webPageMetaResolver = WebPageMetaResolver()

        var persistentStackConf = PersistentStack.Configuration(author: "shareExtension",
                                                                persistentContainerName: "Model",
                                                                managedObjectModelUrl: .managedObjectModelUrl)
        persistentStackConf.persistentContainerUrl = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.\(appBundle.bundleIdentifier!)")!
            .appendingPathComponent("tsundocs.sqlite")
        persistentStackConf.persistentHistoryTokenSaveDirectory = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("TsunDocs", isDirectory: true)
        persistentStackConf.persistentHistoryTokenFileName = "shareExtension-token.data"
        persistentStack = PersistentStack(configuration: persistentStackConf,
                                          isCloudKitEnabled: false)

        commandContext = persistentStack.newBackgroundContext(on: commandQueue)

        _tagQueryService = TagQueryService(persistentStack.viewContext)
        _tsundocCommandService = TsundocCommandService(commandContext)
        _tagCommandService = TagCommandService(commandContext)

        _sharedUserSettingStorage = Persistence.SharedUserSettingStorage(userDefaults: .init(suiteName: "group.\(appBundle.bundleIdentifier!)")!)

        persistentStack.reconfigureIfNeeded(isCloudKitEnabled: false)
    }
}

extension DependencyContainer: HasUrlLoader {
    public var urlLoader: URLLoadable { _sharedUrlLoader }
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

extension DependencyContainer: HasPasteboard {
    public var pasteboard: Pasteboard { UIPasteboard.general }
}

extension DependencyContainer: HasNop {}

extension DependencyContainer: HasSharedUserSettingStorage {
    public var sharedUserSettingStorage: Domain.SharedUserSettingStorage { _sharedUserSettingStorage }
}
