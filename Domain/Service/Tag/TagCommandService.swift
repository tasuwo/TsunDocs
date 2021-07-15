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
    func createAndCommitTag(by command: TagCommand) async throws -> Tag.ID {
        try await perform {
            do {
                try begin()

                let result = createTag(by: command)

                try commit()

                return try result.get()
            } catch {
                try cancel()
                throw error
            }
        }
    }
}
