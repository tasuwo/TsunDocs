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

    public init(author: TransactionAuthor,
                notificationCenter: NotificationCenter = .default)
    {
        self.author = author
        self._persistentContainer = .init(Self.makeContainer())
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
    private static func makeContainer() -> NSPersistentContainer {
        let container = loadContainer()

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        #if os(iOS)
        description.url = containerUrl()
        #endif
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true

        // TODO: CloudKit対応
        description.cloudKitContainerOptions = nil

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
        let bundle = Bundle(for: Self.self)
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url)
        else {
            fatalError("Unable to load Core Data Model")
        }
        return NSPersistentContainer(name: "Model", managedObjectModel: model)
    }

    private static func containerUrl() -> URL {
        guard let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.net.tasuwo.tsundocs") else {
            fatalError("App Group Container could not be created.")
        }
        return containerUrl.appendingPathComponent("tsundocs.sqlite")
    }
}
