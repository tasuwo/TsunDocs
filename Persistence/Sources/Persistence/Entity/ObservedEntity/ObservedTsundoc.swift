//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData
import Domain

class ObservedTsundoc: NSObject {
    private let objectId: NSManagedObjectID
    private let subject: CurrentValueSubject<Domain.Tsundoc, Error>
    private var cancellable: AnyCancellable?

    // MARK: - Initializers

    init?(id: Domain.Tsundoc.ID, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<Tsundoc> = Tsundoc.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let tsundoc = try context.fetch(request).first,
              let domainModel = tsundoc.mapToDomainModel()
        else {
            return nil
        }

        objectId = tsundoc.objectID
        subject = .init(domainModel)

        super.init()

        configureQuery(context)
    }
}

extension ObservedTsundoc {
    func configureQuery(_ context: NSManagedObjectContext) {
        cancellable?.cancel()
        cancellable = NotificationCenter.default
            .publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
            .sink { [weak self] in self?.contextDidChangeNotification(notification: $0) }
    }

    private func contextDidChangeNotification(notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else { return }
        context.perform { [weak self] in
            guard let self = self else { return }

            if let objects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>,
               objects.compactMap({ $0 as? Tsundoc }).contains(where: { $0.objectID == self.objectId })
            {
                self.subject.send(completion: .finished)
                return
            }

            if let objects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>,
               let object = objects.compactMap({ $0 as? Tsundoc }).first(where: { $0.objectID == self.objectId }),
               let tsundoc = object.mapToDomainModel()
            {
                self.subject.send(tsundoc)
                return
            }
        }
    }
}

extension ObservedTsundoc: Domain.ObservedEntity {
    typealias Entity = Domain.Tsundoc

    var value: CurrentValueSubject<Domain.Tsundoc, Error> { subject }
}

extension ObservedTsundoc: ViewContextObserving {
    func didReplaced(context: NSManagedObjectContext) {
        configureQuery(context)
    }
}
