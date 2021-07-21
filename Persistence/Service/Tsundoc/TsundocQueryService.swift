//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class TsundocQueryService: CoreDataQueryService {}

extension TsundocQueryService: Domain.TsundocQueryService {
    public func queryTsundoc(having id: Domain.Tsundoc.ID) -> Result<AnyObservedEntity<Domain.Tsundoc>, QueryServiceError> {
        assert(Thread.isMainThread)

        do {
            guard let query = try ObservedTsundoc(id: id, context: context) else {
                return .failure(.notFound)
            }
            append(query)
            return .success(query.eraseToAnyObservedEntity())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func queryTsundocs(tagged tagId: Domain.Tag.ID) -> Result<AnyObservedEntityArray<Domain.Tsundoc>, QueryServiceError> {
        assert(Thread.isMainThread)

        do {
            let factory: ObservedTsundocArray.RequestFactory = {
                let request: NSFetchRequest<Tsundoc> = Tsundoc.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Tsundoc.createdDate, ascending: false)]
                request.predicate = NSPredicate(format: "SUBQUERY(tags, $tag, $tag.id == %@).@count > 0", tagId as CVarArg)
                return request
            }
            let query = try ObservedTsundocArray(requestFactory: factory, context: context)
            append(query)
            return .success(query.eraseToAnyObservedEntityArray())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func queryAllTsundocs() -> Result<AnyObservedEntityArray<Domain.Tsundoc>, QueryServiceError> {
        assert(Thread.isMainThread)

        do {
            let factory: ObservedTsundocArray.RequestFactory = {
                let request: NSFetchRequest<Tsundoc> = Tsundoc.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Tsundoc.createdDate, ascending: false)]
                return request
            }
            let query = try ObservedTsundocArray(requestFactory: factory, context: context)
            append(query)
            return .success(query.eraseToAnyObservedEntityArray())
        } catch {
            return .failure(.internalError(error))
        }
    }
}
