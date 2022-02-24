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

    let author: TransactionAuthor

    public var viewContext: NSManagedObjectContext {
        return _persistentContainer.value.viewContext
    }

    private let _persistentContainer: CurrentValueSubject<NSPersistentContainer, Never>
    var persistentContainer: AnyPublisher<NSPersistentContainer, Never> {
        _persistentContainer.eraseToAnyPublisher()
    }

    private var historyTracker: PersistentHistoryTracker?

    // MARK: - Initializers

    public init(appBundle: Bundle,
                author: TransactionAuthor,
                notificationCenter: NotificationCenter = .default)
    {
        self.author = author
        self._persistentContainer = .init(Self.makeContainer(forAppBundle: appBundle, author: author))
        self.historyTracker = PersistentHistoryTracker(self)
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

extension PersistentContainer {
    private static func makeContainer(forAppBundle appBundle: Bundle,
                                      author: TransactionAuthor) -> NSPersistentContainer
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

        if author == .shareExtension {
            description.cloudKitContainerOptions = nil
        }

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

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
