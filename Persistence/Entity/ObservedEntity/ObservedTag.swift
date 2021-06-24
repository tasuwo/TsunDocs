//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData
import Domain

class ObservedTag: NSObject {
    private let objectId: NSManagedObjectID
    private let subject: CurrentValueSubject<Domain.Tag, Error>
    private var cancellable: AnyCancellable?

    // MARK: - Initializers

    init?(id: Domain.Tag.ID, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let tag = try context.fetch(request).first,
              let domainModel = tag.mapToDomainModel()
        else {
            return nil
        }

        objectId = tag.objectID
        subject = .init(domainModel)

        super.init()

        configureQuery(context)
    }
}

extension ObservedTag {
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
               objects.compactMap({ $0 as? Tag }).contains(where: { $0.objectID == self.objectId })
            {
                self.subject.send(completion: .finished)
                return
            }

            if let objects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>,
               let object = objects.compactMap({ $0 as? Tag }).first(where: { $0.objectID == self.objectId }),
               let tag = object.mapToDomainModel()
            {
                self.subject.send(tag)
                return
            }
        }
    }
}

extension ObservedTag: Domain.ObservedEntity {
    typealias Entity = Domain.Tag

    var value: CurrentValueSubject<Domain.Tag, Error> { subject }
}

extension ObservedTag: ViewContextObserving {
    func didReplaced(context: NSManagedObjectContext) {
        configureQuery(context)
    }
}
