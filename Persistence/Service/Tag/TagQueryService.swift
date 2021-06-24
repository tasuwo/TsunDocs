//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class TagQueryService: CoreDataQueryService {}

extension TagQueryService: Domain.TagQueryService {
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
