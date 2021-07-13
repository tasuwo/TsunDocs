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
    func createAndCommitTag(by command: TagCommand) -> Result<Tag.ID, CommandServiceError> {
        var result: Result<Tag.ID, CommandServiceError>?
        perform {
            do {
                try begin()

                result = createTag(by: command)

                try commit()
            } catch {
                result = .failure(.internalError(error))
            }
        }
        // swiftlint:disable:next force_unwrapping
        return result!
    }
}
