//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData

class CoreDataStack {
    // MARK: - Properties

    private static let transactionAuthor = "app"

    var viewContext: NSManagedObjectContext {
        return _persistentContainer.value.viewContext
    }

    private let _persistentContainer: CurrentValueSubject<NSPersistentContainer, Never>
    var persistentContainer: AnyPublisher<NSPersistentContainer, Never> {
        _persistentContainer.eraseToAnyPublisher()
    }

    // MARK: - Initializers

    init(notificationCenter: NotificationCenter = .default) {
        self._persistentContainer = .init(Self.loadContainer())
    }

    // MARK: - Methods

    func newBackgroundContext(on queue: DispatchQueue) -> NSManagedObjectContext {
        return queue.sync {
            let context = _persistentContainer.value.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.transactionAuthor = Self.transactionAuthor
            return context
        }
    }
}

extension CoreDataStack {
    private static func loadContainer() -> NSPersistentContainer {
        let container = PersistentContainerLoader.load()

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
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
}
