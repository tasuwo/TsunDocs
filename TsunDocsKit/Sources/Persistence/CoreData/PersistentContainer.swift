//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData

public class PersistentContainer {
    public enum TransactionAuthor: String {
        case app
        case shareExtension
    }

    // MARK: - Properties

    private let appBundle: Bundle
    let author: TransactionAuthor

    public var viewContext: NSManagedObjectContext {
        return _persistentContainer.value.viewContext
    }

    public private(set) var isiCloudSyncEnabled: Bool
    public let reloaded: PassthroughSubject<Void, Never> = .init()

    private let _persistentContainer: CurrentValueSubject<NSPersistentContainer, Never>
    var persistentContainer: AnyPublisher<NSPersistentContainer, Never> {
        _persistentContainer.eraseToAnyPublisher()
    }

    private var historyTracker: PersistentHistoryTracker?

    // MARK: - Initializers

    public init(appBundle: Bundle,
                author: TransactionAuthor,
                isiCloudSyncSettingEnabled: Bool,
                notificationCenter: NotificationCenter = .default)
    {
        self.appBundle = appBundle
        self.author = author
        self.isiCloudSyncEnabled = (author == .app && isiCloudSyncSettingEnabled)
        self._persistentContainer = .init(Self.makeContainer(forAppBundle: appBundle, author: author, isiCloudSyncEnabled: self.isiCloudSyncEnabled))
        self.historyTracker = PersistentHistoryTracker(self)

        self.load()
    }

    // MARK: - Methods

    public func newBackgroundContext(on queue: DispatchQueue = DispatchQueue.global()) -> NSManagedObjectContext {
        return queue.sync {
            let context = _persistentContainer.value.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.transactionAuthor = author.rawValue
            return context
        }
    }
}

public extension PersistentContainer {
    func reload(isiCloudSyncSettingEnabled: Bool) {
        historyTracker?.prepareForReplaceContainer { [weak self] in
            guard let self = self else { return }

            let isiCloudSyncEnabled = (self.author == .app && isiCloudSyncSettingEnabled)

            let container = Self.makeContainer(forAppBundle: self.appBundle, author: self.author, isiCloudSyncEnabled: isiCloudSyncEnabled)

            // iCloud同期中のStoreが残っていると新たなiCloud同期Storeをロードしようとした際に失敗してしまうので、
            // このタイミングで明示的に削除する
            self._persistentContainer.value.persistentStoreCoordinator.persistentStores.forEach {
                try? self._persistentContainer.value.persistentStoreCoordinator.remove($0)
            }

            self._persistentContainer.send(container)
            self.isiCloudSyncEnabled = isiCloudSyncEnabled

            self.load()
            self.reloaded.send(())
        }
    }
}

extension PersistentContainer {
    private func load() {
        _persistentContainer.value.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        _persistentContainer.value.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        _persistentContainer.value.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static func makeContainer(forAppBundle appBundle: Bundle,
                                      author: TransactionAuthor,
                                      isiCloudSyncEnabled: Bool) -> NSPersistentContainer
    {
        let container = loadContainer()

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        #if os(iOS)
        description.url = containerUrl(forAppBundle: appBundle)
        #endif
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true

        if !isiCloudSyncEnabled {
            description.cloudKitContainerOptions = nil
        }

        return container
    }

    private static func loadContainer() -> NSPersistentContainer {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url)
        else {
            fatalError("Unable to load Core Data Model")
        }
        return NSPersistentCloudKitContainer(name: "Model", managedObjectModel: model)
    }

    private static func containerUrl(forAppBundle appBundle: Bundle) -> URL {
        guard let bundleIdentifier = appBundle.bundleIdentifier else {
            fatalError("Failed to resolve bundle identifier")
        }
        guard let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.\(bundleIdentifier)") else {
            fatalError("App Group Container could not be created.")
        }
        return containerUrl.appendingPathComponent("tsundocs.sqlite")
    }
}
