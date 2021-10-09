//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class TagCommandService: CoreDataCommandService {
    private func fetchTag(having id: UUID) throws -> Tag? {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
    }
}

extension TagCommandService: Domain.TagCommandService {
    public func createTag(by command: TagCommand) -> Result<Domain.Tag.ID, CommandServiceError> {
        let id = UUID()

        let tag = Tag(context: context)
        tag.id = id
        tag.name = command.name
        let currentDate = Date()
        tag.createdDate = currentDate
        tag.updatedDate = currentDate

        return .success(id)
    }

    public func updateTag(having id: Domain.Tag.ID, nameTo name: String) -> Result<Void, CommandServiceError> {
        do {
            guard let tag = try fetchTag(having: id) else {
                return .failure(.notFound)
            }

            tag.name = name
            tag.updatedDate = Date()

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func deleteTag(having id: Domain.Tag.ID) -> Result<Void, CommandServiceError> {
        do {
            guard let tag = try fetchTag(having: id) else {
                return .failure(.notFound)
            }

            context.delete(tag)

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }
}
