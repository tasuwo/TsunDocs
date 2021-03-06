//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

/// @mockable
public protocol TagCommandService: Transaction {
    func createTag(by command: TagCommand) -> Result<Tag.ID, CommandServiceError>
    func updateTag(having id: Tag.ID, nameTo name: String) -> Result<Void, CommandServiceError>
    func deleteTag(having id: Tag.ID) -> Result<Void, CommandServiceError>
}

public extension TagCommandService {
    @discardableResult
    func createTag(by command: TagCommand) async throws -> Tag.ID {
        try await perform {
            do {
                try begin()

                let result = try createTag(by: command).get()

                try commit()

                return result
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func updateTag(having id: Tag.ID, nameTo name: String) async throws {
        try await perform {
            do {
                try begin()

                try updateTag(having: id, nameTo: name).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func deleteTag(having id: Tag.ID) async throws {
        try await perform {
            do {
                try begin()

                try deleteTag(having: id).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }
}
