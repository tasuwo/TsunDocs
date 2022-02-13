//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class TsundocCommandService: CoreDataCommandService {
    private func fetchTsundoc(having id: UUID) throws -> Tsundoc? {
        let request: NSFetchRequest<Tsundoc> = Tsundoc.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
    }

    private func fetchTag(having id: UUID) throws -> Tag? {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
    }
}

extension TsundocCommandService: Domain.TsundocCommandService {
    public func createTsundoc(by command: TsundocCommand) -> Result<Domain.Tsundoc.ID, CommandServiceError> {
        let id = UUID()

        let tsundoc = Tsundoc(context: context)
        tsundoc.id = id
        tsundoc.title = command.title
        tsundoc.descriptionText = command.description
        tsundoc.url = command.url
        tsundoc.emojiAlias = command.emojiAlias
        tsundoc.emojiBackgroundColor = command.emojiBackgroundColor?.rawValue
        tsundoc.isUnread = command.isUnread
        tsundoc.imageUrl = command.imageUrl

        let tags: [Tag] = command.tagIds
            .compactMap {
                let requestById: NSFetchRequest<Tag> = Tag.fetchRequest()
                requestById.predicate = NSPredicate(format: "id == %@", $0 as CVarArg)
                return try? context.fetch(requestById).first
            }
        tsundoc.tags = NSSet(array: tags)

        let currentDate = Date()
        tsundoc.createdDate = currentDate
        tsundoc.updatedDate = currentDate

        return .success(id)
    }

    public func updateTsundoc(having id: Domain.Tsundoc.ID, title: String) -> Result<Void, CommandServiceError> {
        do {
            guard let tsundoc = try fetchTsundoc(having: id) else {
                return .failure(.notFound)
            }

            tsundoc.title = title
            tsundoc.updatedDate = Date()

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func updateTsundoc(having id: Domain.Tsundoc.ID, emojiAlias: String?, emojiBackgroundColor: EmojiBackgroundColor?) -> Result<Void, CommandServiceError> {
        do {
            guard let tsundoc = try fetchTsundoc(having: id) else {
                return .failure(.notFound)
            }

            tsundoc.emojiAlias = emojiAlias
            tsundoc.emojiBackgroundColor = emojiBackgroundColor?.rawValue
            tsundoc.updatedDate = Date()

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func updateTsundoc(having id: Domain.Tsundoc.ID, byAddingTagHaving tagId: Domain.Tag.ID) -> Result<Void, CommandServiceError> {
        do {
            guard let tsundoc = try fetchTsundoc(having: id) else {
                return .failure(.notFound)
            }

            guard let tag = try fetchTag(having: id) else {
                return .failure(.notFound)
            }

            let tags = tsundoc.mutableSetValue(forKeyPath: #keyPath(Tsundoc.tags))
            guard !tags.contains(tag) else {
                return .failure(.duplicated)
            }

            tags.add(tag)
            tsundoc.updatedDate = Date()

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func updateTsundoc(having id: Domain.Tsundoc.ID, byRemovingTagHaving tagId: Domain.Tag.ID) -> Result<Void, CommandServiceError> {
        do {
            guard let tsundoc = try fetchTsundoc(having: id) else {
                return .failure(.notFound)
            }

            guard let tag = try fetchTag(having: tagId) else {
                return .failure(.notFound)
            }

            let tags = tsundoc.mutableSetValue(forKeyPath: #keyPath(Tsundoc.tags))
            guard tags.contains(tag) else {
                return .failure(.notFound)
            }

            tags.remove(tag)
            tsundoc.updatedDate = Date()

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func updateTsundoc(having id: Domain.Tsundoc.ID, byReplacingTagsHaving tagIds: Set<Domain.Tag.ID>) -> Result<Void, CommandServiceError> {
        do {
            guard let tsundoc = try fetchTsundoc(having: id) else {
                return .failure(.notFound)
            }

            let newTags = try tagIds
                .compactMap { try fetchTag(having: $0) }

            let tags = tsundoc.mutableSetValue(forKeyPath: #keyPath(Tsundoc.tags))
            tags.removeAllObjects()
            newTags.forEach { tags.add($0) }
            tsundoc.updatedDate = Date()

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }

    public func deleteTsundoc(having id: Domain.Tsundoc.ID) -> Result<Void, CommandServiceError> {
        do {
            guard let tsundoc = try fetchTsundoc(having: id) else {
                return .failure(.notFound)
            }

            context.delete(tsundoc)

            return .success(())
        } catch {
            return .failure(.internalError(error))
        }
    }
}
