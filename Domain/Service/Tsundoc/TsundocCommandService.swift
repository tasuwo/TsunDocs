//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

/// @mockable
public protocol TsundocCommandService: Transaction {
    func createTsundoc(by command: TsundocCommand) -> Result<Tsundoc.ID, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagIds: Set<Tag.ID>) -> Result<Void, CommandServiceError>
    func deleteTsundoc(having id: Tsundoc.ID) -> Result<Void, CommandServiceError>
}

public extension TsundocCommandService {
    @discardableResult
    func createTsundoc(by command: TsundocCommand) async throws -> Domain.Tsundoc.ID {
        try await perform {
            try begin()

            let result = createTsundoc(by: command)

            try commit()

            return try result.get()
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) async throws {
        try await perform { () -> Void in
            try begin()

            let result = updateTsundoc(having: id, byAddingTagHaving: tagId)

            try commit()

            try result.get()
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) async throws {
        try await perform { () -> Void in
            try begin()

            let result = updateTsundoc(having: id, byRemovingTagHaving: tagId)

            try commit()

            try result.get()
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagIds: Set<Tag.ID>) async throws {
        try await perform { () -> Void in
            try begin()

            let result = updateTsundoc(having: id, byReplacingTagsHaving: tagIds)

            try commit()

            try result.get()
        }
    }

    func deleteTsundoc(having id: Tsundoc.ID) async throws {
        try await perform { () -> Void in
            try begin()

            let result = deleteTsundoc(having: id)

            try commit()

            try result.get()
        }
    }
}
