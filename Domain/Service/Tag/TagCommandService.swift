//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol TagCommandService: Transaction {
    func createTag(by command: TagCommand) -> Result<Tag.ID, CommandServiceError>
    func updateTag(having id: Tag.ID, nameTo name: String) -> Result<Void, CommandServiceError>
    func deleteTag(having id: Tag.ID) -> Result<Void, CommandServiceError>
}
