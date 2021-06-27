//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData
import Domain
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

class ObservedTagArray: NSObject {
    typealias RequestFactory = () -> NSFetchRequest<Tag>

    private let requestFactory: RequestFactory
    private let subject: CurrentValueSubject<[Domain.Tag], Error>
    private var controller: NSFetchedResultsController<Tag>? {
        willSet {
            controller?.delegate = nil
        }
    }

    // MARK: - Initializers

    init(requestFactory: @escaping RequestFactory, context: NSManagedObjectContext) throws {
        self.requestFactory = requestFactory

        let request = requestFactory()
        let currentModels = try context.fetch(request)
            .compactMap { $0.mapToDomainModel() }

        subject = .init(currentModels)

        super.init()

        configureQuery(context)
    }
}

extension ObservedTagArray {
    func configureQuery(_ context: NSManagedObjectContext) {
        context.perform { [weak self] in
            guard let self = self else { return }

            self.controller = NSFetchedResultsController(fetchRequest: self.requestFactory(),
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
            self.controller?.delegate = self

            do {
                try self.controller?.performFetch()
            } catch {
                self.subject.send(completion: .failure(error))
            }
        }
    }
}

extension ObservedTagArray: NSFetchedResultsControllerDelegate {
    // MARK: - NSFetchedResultsControllerDelegate

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference)
    {
        controller.managedObjectContext.perform { [weak self] in
            guard let self = self else { return }
            let tags: [Domain.Tag] = (snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>).itemIdentifiers
                .compactMap { controller.managedObjectContext.object(with: $0) as? Tag }
                .compactMap { $0.mapToDomainModel() }
            self.subject.send(tags)
        }
    }
}

extension ObservedTagArray: Domain.ObservedEntityArray {
    typealias Entity = Domain.Tag

    var values: CurrentValueSubject<[Domain.Tag], Error> { subject }
}

extension ObservedTagArray: ViewContextObserving {
    func didReplaced(context: NSManagedObjectContext) {
        configureQuery(context)
    }
}
