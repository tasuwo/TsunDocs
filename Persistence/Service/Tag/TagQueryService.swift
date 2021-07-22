//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class TagQueryService: CoreDataQueryService {}

extension TagQueryService: Domain.TagQueryService {
    public func fetchTags(taggedToTsundocHaving id: Domain.Tsundoc.ID) -> Result<Set<Domain.Tag>, QueryServiceError> {
        do {
            let request: NSFetchRequest<Tsundoc> = Tsundoc.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            guard let tsundoc = try context.fetch(request).first else {
                return .failure(.notFound)
            }

            let maybeTags = tsundoc.tags?
                .compactMap { $0 as? Tag }
                .compactMap { $0.mapToDomainModel() }

            guard let tags = maybeTags, !tags.isEmpty else {
                return .failure(.notFound)
            }

            return .success(Set(tags))
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func queryTag(having id: Domain.Tag.ID) -> Result<AnyObservedEntity<Domain.Tag>, QueryServiceError> {
        assert(Thread.isMainThread)

        do {
            guard let query = try ObservedTag(id: id, context: context) else {
                return .failure(.notFound)
            }
            append(query)
            return .success(query.eraseToAnyObservedEntity())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func queryAllTags() -> Result<AnyObservedEntityArray<Domain.Tag>, QueryServiceError> {
        assert(Thread.isMainThread)

        do {
            let factory: ObservedTagArray.RequestFactory = {
                let request: NSFetchRequest<Tag> = Tag.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.createdDate, ascending: false)]
                return request
            }
            let query = try ObservedTagArray(requestFactory: factory, context: context)
            append(query)
            return .success(query.eraseToAnyObservedEntityArray())
        } catch {
            return .failure(.internalError(error))
        }
    }
}
