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

class ObservedTsundocArray: NSObject {
    typealias RequestFactory = () -> NSFetchRequest<Tsundoc>

    private let requestFactory: RequestFactory
    private let subject: CurrentValueSubject<[Domain.Tsundoc], Error>
    private var controller: NSFetchedResultsController<Tsundoc>? {
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

extension ObservedTsundocArray {
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

extension ObservedTsundocArray: NSFetchedResultsControllerDelegate {
    // MARK: - NSFetchedResultsControllerDelegate

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference)
    {
        controller.managedObjectContext.perform { [weak self] in
            guard let self = self else { return }
            let tsundocs: [Domain.Tsundoc] = (snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>).itemIdentifiers
                .compactMap { controller.managedObjectContext.object(with: $0) as? Tsundoc }
                .compactMap { $0.mapToDomainModel() }
            self.subject.send(tsundocs)
        }
    }
}

extension ObservedTsundocArray: Domain.ObservedEntityArray {
    typealias Entity = Domain.Tsundoc

    var values: CurrentValueSubject<[Domain.Tsundoc], Error> { subject }
}

extension ObservedTsundocArray: ViewContextObserving {
    func didReplaced(context: NSManagedObjectContext) {
        configureQuery(context)
    }
}
