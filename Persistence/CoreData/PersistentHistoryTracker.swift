//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData

class PersistentHistoryTracker {
    // MARK: - Properties

    private var lastHistoryToken: NSPersistentHistoryToken? {
        didSet {
            guard let token = lastHistoryToken,
                  let data = try? NSKeyedArchiver.archivedData(withRootObject: token,
                                                               requiringSecureCoding: true)
            else {
                return
            }

            try? data.write(to: tokenFile)
        }
    }

    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("TsunDocs", isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }

        // swiftlint:disable:next
        return url.appendingPathComponent("\(container!.author.rawValue)-token.data", isDirectory: false)
    }()

    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private let notificationCenter: NotificationCenter = .default
    private weak var container: PersistentContainer?
    private var cancellable: AnyCancellable?
    private var remoteChangeCancellable: AnyCancellable?

    // MARK: - Initializers

    init(_ container: PersistentContainer) {
        self.container = container

        if let tokenData = try? Data(contentsOf: tokenFile) {
            lastHistoryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self,
                                                                       from: tokenData)
        }

        cancellable = container.persistentContainer
            .sink { [weak self] in
                self?.remoteChangeCancellable?.cancel()
                self?.remoteChangeCancellable = self?.notificationCenter
                    .publisher(for: .NSPersistentStoreRemoteChange,
                               object: $0.persistentStoreCoordinator)
                    .sink { self?.mergeRemoteChange($0) }
            }
    }

    // MARK: - Methods

    private func mergeRemoteChange(_ notification: Notification) {
        historyQueue.addOperation { [weak self] in self?.fetch() }
    }

    private func fetch() {
        guard let container = container else { return }
        let context = container.newBackgroundContext()
        context.performAndWait {
            guard let transactions = try? PersistentHistoryFetcher.fetch(after: lastHistoryToken, with: context) else {
                return
            }

            container.viewContext.perform {
                transactions.merge(into: container.viewContext)
            }

            lastHistoryToken = transactions.last?.token
        }
    }
}

private extension Collection where Element == NSPersistentHistoryTransaction {
    func merge(into context: NSManagedObjectContext) {
        forEach { transaction in
            guard let userInfo = transaction.objectIDNotification().userInfo else { return }
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
        }
    }
}
